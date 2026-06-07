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
import 'package:carfy/common/widgets/dotted_line_painter.dart';
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
            prev.selectedPaymentMethod != curr.selectedPaymentMethod,
        builder: (context, state) {
          if (state.preview == null) return const SizedBox.shrink();
          return _PaymentDetailsBar(
            preview: state.preview!,
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
        if (state.previewStatus is StateStatusLoading || state.preview == null)
          const _ItemsShimmer()
        else
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
                seller.subtotal.manatFormatted,
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
                'x${item.quantity}  ·  ${item.price.manatFormatted}',
                style: const TextStyle(fontSize: 12, color: Color(0xFF717171)),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Text(
          (item.price * item.quantity).manatFormatted,
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

// ── Payment Details Bar (bottom) ──

class _PaymentDetailsBar extends StatelessWidget {
  final CheckoutPreview preview;
  final bool isLoading;
  final bool isPreviewLoading;
  final bool canCheckout;
  final VoidCallback onCheckout;

  const _PaymentDetailsBar({
    required this.preview,
    required this.isLoading,
    required this.isPreviewLoading,
    required this.canCheckout,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    final totalItems = preview.sellers.fold<int>(
      0,
      (sum, s) => sum + s.items.fold<int>(0, (a, i) => a + i.quantity),
    );
    final discount =
        preview.subtotal + preview.totalShipping - preview.grandTotal;
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: context.theme.colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 16,
              offset: Offset(0, -4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.localization.paymentDetails,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: context.theme.colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                _buildDetailRow(
                  context,
                  context.localization.amount,
                  preview.subtotal.manatFormatted,
                ),
                _buildDetailRow(
                  context,
                  context.localization.productCount,
                  '$totalItems ${context.localization.piece}',
                ),
                _buildDetailRow(
                  context,
                  context.localization.deliveryFee,
                  preview.totalShipping.manatFormatted,
                ),
                _buildDetailRow(
                  context,
                  context.localization.discount,
                  (discount > 0 ? discount : 0.0).manatFormatted,
                ),
                _buildDetailRow(
                  context,
                  context.localization.total,
                  preview.grandTotal.manatFormatted,
                  isBold: true,
                ),
                const SizedBox(height: 12),
                CustomButton(
                  onPressed: canCheckout && !isLoading && !isPreviewLoading
                      ? onCheckout
                      : null,
                  loading: isLoading,
                  text: context.localization.formOrder,
                ),
              ],
            ),
            if (isPreviewLoading)
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    color: Colors.white.withValues(alpha: 0.6),
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      color: context.theme.colors.primary,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value, {
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.w500 : FontWeight.w400,
              color: context.theme.colors.textDark,
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              height: 1,
              child: CustomPaint(painter: DottedLinePainter()),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
              color: isBold
                  ? context.theme.colors.primary
                  : context.theme.colors.textGray,
            ),
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
