import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carfy/common/extensions/price_extension.dart';
import 'package:carfy/common/router/app_router.dart';
import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/common/widgets/custom_app_bar.dart';
import 'package:carfy/common/widgets/custom_button.dart';
import 'package:carfy/common/widgets/custom_text_field.dart';
import 'package:carfy/common/widgets/shimmer_wrapper.dart';
import 'package:carfy/common/widgets/state_status_toast.dart';
import 'package:carfy/domain/entities/address/address.dart';
import 'package:carfy/domain/entities/orders/checkout_preview.dart';
import 'package:carfy/domain/entities/payment/payment_method.dart';
import 'package:carfy/gen/assets.gen.dart';
import 'package:carfy/presentation/order_confirm/state/order_confirm_cubit.dart';
import 'package:carfy/presentation/order_confirm/ui/widget/address_picker_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

@RoutePage()
class OrderConfirmPage extends StatelessWidget implements AutoRouteWrapper {
  const OrderConfirmPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (_) => OrderConfirmCubit()..load(),
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colors.bg,
      appBar: CustomAppBar(title: context.localization.orderConfirmTitle),
      body: MultiBlocListener(
        listeners: [
          BlocListener<OrderConfirmCubit, OrderConfirmState>(
            listenWhen: (prev, curr) =>
                prev.previewStatus != curr.previewStatus,
            listener: (context, state) =>
                showStateStatusToast(context, state.previewStatus),
          ),
          BlocListener<OrderConfirmCubit, OrderConfirmState>(
            listenWhen: (prev, curr) =>
                prev.addressesStatus != curr.addressesStatus,
            listener: (context, state) =>
                showStateStatusToast(context, state.addressesStatus),
          ),
          BlocListener<OrderConfirmCubit, OrderConfirmState>(
            listenWhen: (prev, curr) =>
                prev.checkoutStatus != curr.checkoutStatus,
            listener: _handleCheckoutStatus,
          ),
        ],
        child: BlocBuilder<OrderConfirmCubit, OrderConfirmState>(
          builder: (context, state) => _OrderConfirmContent(state: state),
        ),
      ),
      bottomNavigationBar: BlocBuilder<OrderConfirmCubit, OrderConfirmState>(
        buildWhen: (prev, curr) =>
            prev.preview != curr.preview ||
            prev.previewStatus != curr.previewStatus ||
            prev.checkoutStatus != curr.checkoutStatus ||
            prev.selectedAddress != curr.selectedAddress ||
            prev.selectedPaymentMethod != curr.selectedPaymentMethod ||
            prev.useReferralBalance != curr.useReferralBalance,
        builder: (context, state) {
          if (state.preview == null) return const SizedBox.shrink();
          return _PaymentDetailsBar(
            preview: state.preview!,
            useReferralBalance: state.useReferralBalance,
            isLoading: state.checkoutStatus is StateStatusLoading,
            isPreviewLoading: state.previewStatus is StateStatusLoading,
            canCheckout:
                state.selectedAddress != null &&
                state.selectedPaymentMethod != null,
            onCheckout: () {
              if (state.selectedAddress == null) {
                showStateStatusToast(
                  context,
                  StateStatus.failure(
                    context.localization.orderConfirmAddressRequired,
                  ),
                );
                return;
              }
              context.read<OrderConfirmCubit>().checkout();
            },
          );
        },
      ),
    );
  }

  Future<void> _handleCheckoutStatus(
    BuildContext context,
    OrderConfirmState state,
  ) async {
    final status = state.checkoutStatus;
    showStateStatusToast(context, status);
    if (status is! StateStatusSuccess) return;

    final result = state.checkoutResult;
    final preview = state.preview;
    final address = state.selectedAddress;
    if (result == null || preview == null || address == null) return;

    if (result.requiresWebviewPayment) {
      final paid = await context.router.push<bool>(
        PaymentWebviewRoute(redirectUrl: result.redirectUrl!),
      );
      if (!context.mounted) return;
      if (paid == true) {
        await context.router.replaceAll([
          const MainRoute(),
          OrderSuccessRoute(preview: preview, address: address),
        ]);
      } else {
        showStateStatusToast(
          context,
          StateStatus.failure(context.localization.paymentFailed),
        );
        context.read<OrderConfirmCubit>().resetCheckoutStatus();
      }
    } else {
      await context.router.replaceAll([
        const MainRoute(),
        OrderSuccessRoute(preview: preview, address: address),
      ]);
    }
  }
}

class _OrderConfirmContent extends StatelessWidget {
  final OrderConfirmState state;

  const _OrderConfirmContent({required this.state});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      children: [
        if (state.previewStatus is StateStatusLoading)
          const _ItemsShimmer()
        else if (state.preview != null)
          for (int i = 0; i < state.preview!.sellers.length; i++) ...[
            _SellerCard(seller: state.preview!.sellers[i]),
            const SizedBox(height: 12),
          ],
        const SizedBox(height: 4),
        if (state.addressesStatus is StateStatusLoading)
          const _AddressShimmer()
        else
          _AddressCard(
            selectedAddress: state.selectedAddress,
            onTap: () async {
              final picked = await showAddressPickerBottomSheet(
                context,
                selectedAddress: state.selectedAddress,
              );
              if (picked != null && context.mounted) {
                context.read<OrderConfirmCubit>().selectAddress(picked);
              }
            },
          ),
        const SizedBox(height: 20),
        if (state.paymentMethodsStatus is StateStatusLoading)
          const _PaymentMethodsShimmer()
        else if (state.paymentMethods.isNotEmpty)
          _PaymentMethodsSection(
            methods: state.paymentMethods,
            selected: state.selectedPaymentMethod,
            onSelected: (method) =>
                context.read<OrderConfirmCubit>().selectPaymentMethod(method),
          ),
        const SizedBox(height: 20),
        _NoteSection(
          initialNote: state.note,
          onChanged: (value) =>
              context.read<OrderConfirmCubit>().setNote(value),
        ),
      ],
    );
  }
}

// ── Seller Card ──

class _SellerCard extends StatelessWidget {
  final CheckoutPreviewSeller seller;

  const _SellerCard({required this.seller});

  @override
  Widget build(BuildContext context) {
    final itemsTotal = seller.items.fold<double>(
      0,
      (sum, item) => sum + item.price,
    );
    final total = itemsTotal + seller.shipping;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        shadows: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.storefront_outlined,
                size: 18,
                color: context.theme.colors.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  seller.storeCode,
                  style: TextStyle(
                    color: context.theme.colors.textDark,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                total.manatFormatted,
                style: TextStyle(
                  color: context.theme.colors.primary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (final item in seller.items) ...[
            _ProductItemRow(item: item),
            const SizedBox(height: 8),
          ],
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                context.localization.shippingLabel,
                style: TextStyle(
                  color: context.theme.colors.textLight,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                seller.shipping.manatFormatted,
                style: TextStyle(
                  color: context.theme.colors.textDark,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.access_time,
                size: 14,
                color: context.theme.colors.textLight,
              ),
              const SizedBox(width: 4),
              Text(
                '~${seller.shippingEtaMinutes} ${context.localization.shippingMinutes}',
                style: TextStyle(
                  color: context.theme.colors.textLight,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProductItemRow extends StatelessWidget {
  final CheckoutPreviewItem item;

  const _ProductItemRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE7F2FC)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: item.product.hoverImage != null
                ? CachedNetworkImage(
                    imageUrl: item.product.hoverImage!,
                    fit: BoxFit.cover,
                    placeholder: (_, __) =>
                        Container(color: const Color(0xFFF0F0F0)),
                    errorWidget: (_, __, ___) =>
                        Container(color: const Color(0xFFF0F0F0)),
                  )
                : Container(color: const Color(0xFFF0F0F0)),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.product.title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF242323),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                'x${item.quantity}  ·  ${item.product.priceFinal.manatFormatted}',
                style: const TextStyle(fontSize: 12, color: Color(0xFF717171)),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Text(
          item.price.manatFormatted,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: context.theme.colors.textDark,
          ),
        ),
      ],
    );
  }
}

// ── Compact Checkout Bar (bottom) ──

class _PaymentDetailsBar extends StatefulWidget {
  final CheckoutPreview preview;
  final bool useReferralBalance;
  final bool isLoading;
  final bool isPreviewLoading;
  final bool canCheckout;
  final VoidCallback onCheckout;

  const _PaymentDetailsBar({
    required this.preview,
    this.useReferralBalance = false,
    required this.isLoading,
    required this.isPreviewLoading,
    required this.canCheckout,
    required this.onCheckout,
  });

  @override
  State<_PaymentDetailsBar> createState() => _PaymentDetailsBarState();
}

class _PaymentDetailsBarState extends State<_PaymentDetailsBar> with SingleTickerProviderStateMixin {
  OverlayEntry? _overlayEntry;
  late final AnimationController _animController;
  double _dragOffset = 0;
  double _panelHeight = 0;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  double _effectiveTotal() {
    final r = widget.preview.referral;
    double total;
    if (r != null && (r.freeDeliveryApplied || r.discountApplied)) {
      total = r.grandTotalAfterPerks;
    } else {
      total = widget.preview.grandTotal;
    }
    if (r != null && r.canUseBalance && widget.useReferralBalance) {
      total -= r.availableBalance.clamp(0.0, total);
    }
    return total;
  }

  void _toggle() {
    if (_overlayEntry != null) {
      _animateClose();
    } else {
      _open();
    }
  }

  void closeIfOpen() {
    if (_overlayEntry != null) _close();
  }

  void _open() {
    final renderBox = context.findRenderObject() as RenderBox;
    final barTop = renderBox.localToGlobal(Offset.zero).dy;
    final cubit = context.read<OrderConfirmCubit>();
    final screenHeight = MediaQuery.of(context).size.height;
    final aboveBarHeight = screenHeight - barTop;

    _overlayEntry = OverlayEntry(
      builder: (ctx) {
        return AnimatedBuilder(
          animation: _animController,
          builder: (context, _) {
            // During drag: use _dragOffset. During animation: use animation value.
            final slideOffset = _dragOffset > 0 ? _dragOffset : (_panelHeight * (1 - _animController.value));

            return Stack(
              children: [
                // Scrim — only above the bar
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  bottom: aboveBarHeight,
                  child: GestureDetector(
                    onTap: _animateClose,
                    child: Container(color: Colors.black26.withValues(alpha: 0.26 * _animController.value)),
                  ),
                ),
                // Panel above bar — clipped
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  bottom: aboveBarHeight,
                  child: ClipRect(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Transform.translate(
                        offset: Offset(0, slideOffset),
                        child: GestureDetector(
                          onVerticalDragUpdate: (details) {
                            _dragOffset = (_dragOffset + (details.primaryDelta ?? 0)).clamp(0.0, double.infinity);
                            _overlayEntry?.markNeedsBuild();
                          },
                          onVerticalDragEnd: (details) {
                            if (_dragOffset > 80 || (details.primaryVelocity ?? 0) > 500) {
                              _animateClose();
                            } else {
                              _dragOffset = 0;
                              _overlayEntry?.markNeedsBuild();
                            }
                          },
                          child: BlocProvider.value(
                            value: cubit,
                            child: Material(
                              color: Colors.white,
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                              child: _MeasureSize(
                                onChange: (size) {
                                  if (_panelHeight != size.height) {
                                    _panelHeight = size.height;
                                  }
                                },
                                child: _PaymentDetailsSheetContent(preview: widget.preview),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
    _dragOffset = 0;
    _animController.forward(from: 0);
    setState(() {});
  }

  void _animateClose() {
    // Start animation from current drag position
    if (_panelHeight > 0 && _dragOffset > 0) {
      final currentProgress = 1.0 - (_dragOffset / _panelHeight).clamp(0.0, 1.0);
      _animController.value = currentProgress;
    }
    _dragOffset = 0;
    _animController.reverse().then((_) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      if (mounted) setState(() {});
    });
  }

  void _close() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _dragOffset = 0;
    _animController.value = 0;
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = _effectiveTotal();
    final bottomPadding = MediaQuery.of(context).padding.bottom + 2;
    final isOpen = _overlayEntry != null;

    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: bottomPadding,
        top: 8,
      ),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE0E0E0)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: _toggle,
                behavior: HitTestBehavior.opaque,
                child: SizedBox(
                  height: 56,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        AnimatedRotation(
                          turns: isOpen ? 0.5 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            Icons.keyboard_arrow_up_rounded,
                            size: 20,
                            color: context.theme.colors.primary,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          total.manatFormatted,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: context.theme.colors.textDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: SizedBox(
                height: 56,
                child: Material(
                  color: widget.canCheckout && !widget.isPreviewLoading
                      ? context.theme.colors.primary
                      : const Color(0xFFB0B0B0),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                  child: InkWell(
                    onTap:
                        widget.canCheckout &&
                            !widget.isLoading &&
                            !widget.isPreviewLoading
                        ? () {
                            closeIfOpen();
                            widget.onCheckout();
                          }
                        : null,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                    child: Center(
                      child: widget.isLoading || widget.isPreviewLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : Text(
                              context.localization.formOrder,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentDetailsSheetContent extends StatelessWidget {
  final CheckoutPreview preview;

  const _PaymentDetailsSheetContent({required this.preview});

  @override
  Widget build(BuildContext context) {
    final r = preview.referral;
    final hasPerks = r != null && (r.freeDeliveryApplied || r.discountApplied);
    final totalItems = preview.sellers.fold<int>(
      0,
      (sum, s) => sum + s.items.fold<int>(0, (a, i) => a + i.quantity),
    );
    final displaySubtotal = hasPerks
        ? r!.subtotalAfterDiscount
        : preview.subtotal;
    final displayShipping = hasPerks
        ? r!.shippingAfterPerk
        : preview.totalShipping;
    final displayTotal = hasPerks
        ? r!.grandTotalAfterPerks
        : preview.grandTotal;
    final isFreeShipping = r?.freeDeliveryApplied == true;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            context.localization.paymentDetails,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF242323),
            ),
          ),
          const SizedBox(height: 16),
          if (hasPerks) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F4FD),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFBBDEF5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (r!.freeDeliveryApplied)
                    Row(
                      children: [
                        const Icon(
                          Icons.local_shipping_outlined,
                          size: 14,
                          color: Color(0xFF4CAF50),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          context.localization.freeDeliveryApplied,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF242323),
                          ),
                        ),
                      ],
                    ),
                  if (r.freeDeliveryApplied && r.discountApplied)
                    const SizedBox(height: 4),
                  if (r.discountApplied)
                    Row(
                      children: [
                        const Icon(
                          Icons.discount_outlined,
                          size: 14,
                          color: Color(0xFF3696E7),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${context.localization.referralDiscountApplied}: -${r.discountAmount.manatFormatted}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF242323),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
          _DetailRow(
            label: context.localization.amount,
            value: preview.subtotal.manatFormatted,
          ),
          _DetailRow(
            label: context.localization.productCount,
            value: '$totalItems ${context.localization.piece}',
          ),
          _DeliveryRow(
            label: context.localization.deliveryFee,
            originalPrice: preview.totalShipping,
            isFree: isFreeShipping,
            freeLabel: context.localization.freeLabel,
          ),
          if (r != null && r.discountApplied)
            _DetailRow(
              label: context.localization.discount,
              value: '-${r.discountAmount.manatFormatted}',
              valueColor: const Color(0xFF00569C),
            ),
          // Balance + total — reactive to useReferralBalance
          BlocBuilder<OrderConfirmCubit, OrderConfirmState>(
            buildWhen: (prev, curr) => prev.useReferralBalance != curr.useReferralBalance,
            builder: (context, state) {
              final balanceDeduction = (r != null && r.canUseBalance && state.useReferralBalance)
                  ? r.availableBalance.clamp(0.0, displayTotal)
                  : 0.0;
              final finalTotal = displayTotal - balanceDeduction;

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (r != null && r.canUseBalance && state.useReferralBalance)
                    _DetailRow(
                      label: context.localization.useReferralBalance,
                      value: '-${balanceDeduction.manatFormatted}',
                      valueColor: const Color(0xFF00569C),
                    ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Divider(height: 1, color: Color(0xFFEEEEEE)),
                  ),
                  _DetailRow(
                    label: context.localization.total,
                    value: finalTotal.manatFormatted,
                    isBold: true,
                    valueColor: const Color(0xFF00569C),
                  ),
                  if (r != null && r.canUseBalance) ...[
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () => context.read<OrderConfirmCubit>().toggleUseReferralBalance(!state.useReferralBalance),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F4FD),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFBBDEF5)),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 20, height: 20,
                              child: Checkbox(
                                value: state.useReferralBalance,
                                onChanged: (v) => context.read<OrderConfirmCubit>().toggleUseReferralBalance(v ?? false),
                                activeColor: context.theme.colors.primary,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(context.localization.useReferralBalance, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: context.theme.colors.primary)),
                                  Text('${context.localization.referralAvailableBalance}: ${r.availableBalance.manatFormatted}', style: const TextStyle(fontSize: 10, color: Color(0xFF717171))),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final Color? valueColor;

  const _DetailRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
              color: const Color(0xFF242323),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
              color: valueColor ?? const Color(0xFF717171),
            ),
          ),
        ],
      ),
    );
  }
}

class _DeliveryRow extends StatelessWidget {
  final String label;
  final double originalPrice;
  final bool isFree;
  final String freeLabel;

  const _DeliveryRow({
    required this.label,
    required this.originalPrice,
    required this.isFree,
    required this.freeLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xFF242323)),
          ),
          if (isFree)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  originalPrice.manatFormatted,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF999999),
                    decoration: TextDecoration.lineThrough,
                    decorationColor: Color(0xFF999999),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  freeLabel,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF4CAF50)),
                ),
              ],
            )
          else
            Text(
              originalPrice.manatFormatted,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF717171)),
            ),
        ],
      ),
    );
  }
}

// ── Note Section ──

class _NoteSection extends StatefulWidget {
  final String initialNote;
  final ValueChanged<String> onChanged;

  const _NoteSection({required this.initialNote, required this.onChanged});

  @override
  State<_NoteSection> createState() => _NoteSectionState();
}

class _NoteSectionState extends State<_NoteSection> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialNote);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            context.localization.orderConfirmNote,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 8),
        CustomTextField(
          controller: _controller,
          hint: context.localization.orderConfirmNoteHint,
          onChanged: widget.onChanged,
          minLines: 3,
          maxLines: 5,
          fillColor: Colors.white,
          hasBorder: false,
          borderRadius: 16,
        ),
      ],
    );
  }
}

// ── Payment Methods ──

class _PaymentMethodsSection extends StatelessWidget {
  final List<PaymentMethod> methods;
  final PaymentMethod? selected;
  final ValueChanged<PaymentMethod> onSelected;

  const _PaymentMethodsSection({
    required this.methods,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            context.localization.orderConfirmPaymentMethod,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 12),
        for (int i = 0; i < methods.length; i++) ...[
          _PaymentMethodTile(
            method: methods[i],
            isSelected: selected?.value == methods[i].value,
            onTap: () => onSelected(methods[i]),
          ),
          if (i != methods.length - 1) const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _PaymentMethodTile extends StatelessWidget {
  final PaymentMethod method;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentMethodTile({
    required this.method,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 2,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                method.label,
                style: const TextStyle(
                  color: Color(0xFF242323),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            _RadioDot(isSelected: isSelected),
          ],
        ),
      ),
    );
  }
}

class _RadioDot extends StatelessWidget {
  final bool isSelected;

  const _RadioDot({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 18,
      height: 18,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFF3696E7)),
          borderRadius: BorderRadius.circular(17),
        ),
      ),
      alignment: Alignment.center,
      child: AnimatedScale(
        scale: isSelected ? 1 : 0,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutBack,
        child: Container(
          width: 12,
          height: 12,
          decoration: const ShapeDecoration(
            color: Color(0xFF3696E7),
            shape: OvalBorder(),
          ),
        ),
      ),
    );
  }
}

// ── Address Card ──

class _AddressCard extends StatelessWidget {
  final Address? selectedAddress;
  final VoidCallback onTap;

  const _AddressCard({required this.selectedAddress, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 2,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: SvgPicture.asset(
                selectedAddress == null
                    ? Assets.icons.plusSquare
                    : Assets.icons.map,
                colorFilter: ColorFilter.mode(
                  context.theme.colors.primary,
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: selectedAddress == null
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.localization.orderConfirmAddAddress,
                          style: const TextStyle(
                            color: Color(0xFF292929),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            height: 1.6,
                            letterSpacing: 0.42,
                          ),
                        ),
                        Text(
                          context.localization.orderConfirmAddAddressHint,
                          style: const TextStyle(
                            color: Color(0xFF717171),
                            fontSize: 9,
                            fontWeight: FontWeight.w400,
                            height: 1.6,
                            letterSpacing: 0.27,
                          ),
                        ),
                      ],
                    )
                  : Text(
                      '${selectedAddress!.city.title},\n${selectedAddress!.addressLine1}',
                      style: const TextStyle(
                        color: Color(0xFF717171),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        height: 1.6,
                        letterSpacing: 0.36,
                      ),
                    ),
            ),
            if (selectedAddress != null) ...[
              const SizedBox(width: 8),
              Text(
                context.localization.orderConfirmEditAddress,
                style: TextStyle(
                  color: context.theme.colors.secondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.36,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Shimmers ──

class _ItemsShimmer extends StatelessWidget {
  const _ItemsShimmer();

  @override
  Widget build(BuildContext context) {
    return ShimmerWrapper(
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}

class _AddressShimmer extends StatelessWidget {
  const _AddressShimmer();

  @override
  Widget build(BuildContext context) {
    return ShimmerWrapper(
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

class _PaymentMethodsShimmer extends StatelessWidget {
  const _PaymentMethodsShimmer();

  @override
  Widget build(BuildContext context) {
    return ShimmerWrapper(
      child: Column(
        children: List.generate(
          2,
          (_) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Container(
              height: 64,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MeasureSize extends StatefulWidget {
  final Widget child;
  final ValueChanged<Size> onChange;

  const _MeasureSize({required this.child, required this.onChange});

  @override
  State<_MeasureSize> createState() => _MeasureSizeState();
}

class _MeasureSizeState extends State<_MeasureSize> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
  }

  void _measure() {
    final box = context.findRenderObject() as RenderBox?;
    if (box != null && box.hasSize) {
      widget.onChange(box.size);
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
