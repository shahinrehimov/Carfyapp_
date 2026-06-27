import 'package:carfy/common/extensions/price_extension.dart';
import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/domain/entities/orders/checkout_preview.dart';
import 'package:carfy/presentation/order_confirm/state/order_confirm_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentDetailsBar extends StatefulWidget {
  final CheckoutPreview preview;
  final bool useReferralBalance;
  final bool isLoading;
  final bool isPreviewLoading;
  final bool canCheckout;
  final VoidCallback onCheckout;

  const PaymentDetailsBar({
    super.key,
    required this.preview,
    this.useReferralBalance = false,
    required this.isLoading,
    required this.isPreviewLoading,
    required this.canCheckout,
    required this.onCheckout,
  });

  @override
  State<PaymentDetailsBar> createState() => PaymentDetailsBarState();
}

class PaymentDetailsBarState extends State<PaymentDetailsBar> with SingleTickerProviderStateMixin {
  OverlayEntry? _overlayEntry;
  late final AnimationController _animController;
  double _dragOffset = 0;
  double _panelHeight = 0;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
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
            final slideOffset = _dragOffset > 0 ? _dragOffset : (_panelHeight * (1 - _animController.value));

            return Stack(
              children: [
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
                                  if (_panelHeight != size.height) _panelHeight = size.height;
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
      padding: EdgeInsets.only(left: 16, right: 16, bottom: bottomPadding, top: 8),
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
                          child: Icon(Icons.keyboard_arrow_up_rounded, size: 20, color: context.theme.colors.primary),
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
                    onTap: widget.canCheckout && !widget.isLoading && !widget.isPreviewLoading
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
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                            )
                          : Text(
                              context.localization.formOrder,
                              style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
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

// ── Sheet Content ──

class _PaymentDetailsSheetContent extends StatelessWidget {
  final CheckoutPreview preview;

  const _PaymentDetailsSheetContent({required this.preview});

  @override
  Widget build(BuildContext context) {
    final r = preview.referral;
    final hasPerks = r != null && (r.freeDeliveryApplied || r.discountApplied);
    final totalItems = preview.sellers.fold<int>(0, (sum, s) => sum + s.items.fold<int>(0, (a, i) => a + i.quantity));
    final displayTotal = hasPerks ? r.grandTotalAfterPerks : preview.grandTotal;
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
              decoration: BoxDecoration(color: const Color(0xFFD9D9D9), borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            context.localization.paymentDetails,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF242323)),
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
                  if (r.freeDeliveryApplied)
                    Row(
                      children: [
                        const Icon(Icons.local_shipping_outlined, size: 14, color: Color(0xFF4CAF50)),
                        const SizedBox(width: 6),
                        Text(
                          context.localization.freeDeliveryApplied,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF242323)),
                        ),
                      ],
                    ),
                  if (r.freeDeliveryApplied && r.discountApplied) const SizedBox(height: 4),
                  if (r.discountApplied)
                    Row(
                      children: [
                        const Icon(Icons.discount_outlined, size: 14, color: Color(0xFF3696E7)),
                        const SizedBox(width: 6),
                        Text(
                          '${context.localization.referralDiscountApplied}: -${r.discountAmount.manatFormatted}',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF242323)),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
          _DetailRow(label: context.localization.amount, value: preview.subtotal.manatFormatted),
          _DetailRow(label: context.localization.productCount, value: '$totalItems ${context.localization.piece}'),
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
                      onTap: () =>
                          context.read<OrderConfirmCubit>().toggleUseReferralBalance(!state.useReferralBalance),
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
                              width: 20,
                              height: 20,
                              child: Checkbox(
                                value: state.useReferralBalance,
                                onChanged: (v) =>
                                    context.read<OrderConfirmCubit>().toggleUseReferralBalance(v ?? false),
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
                                  Text(
                                    context.localization.useReferralBalance,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: context.theme.colors.primary,
                                    ),
                                  ),
                                  Text(
                                    '${context.localization.referralAvailableBalance}: ${r.availableBalance.manatFormatted}',
                                    style: const TextStyle(fontSize: 10, color: Color(0xFF717171)),
                                  ),
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

// ── Detail Rows ──

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final Color? valueColor;

  const _DetailRow({required this.label, required this.value, this.isBold = false, this.valueColor});

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

  const _DeliveryRow({required this.label, required this.originalPrice, required this.isFree, required this.freeLabel});

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

// ── Measure Size Helper ──

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
    if (box != null && box.hasSize) widget.onChange(box.size);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
