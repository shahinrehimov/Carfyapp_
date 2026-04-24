import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carfy/common/extensions/price_extension.dart';
import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/common/widgets/custom_app_bar.dart';
import 'package:carfy/common/widgets/custom_button.dart';
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
      body: BlocListener<OrderConfirmCubit, OrderConfirmState>(
        listenWhen: (prev, curr) => prev.previewStatus != curr.previewStatus,
        listener: (context, state) => showStateStatusToast(context, state.previewStatus),
        child: BlocBuilder<OrderConfirmCubit, OrderConfirmState>(
          builder: (context, state) {
            return state.previewStatus.maybeWhen(
              success: () => _OrderConfirmContent(state: state),
              orElse: () => const _OrderConfirmLoading(),
            );
          },
        ),
      ),
      bottomNavigationBar: BlocBuilder<OrderConfirmCubit, OrderConfirmState>(
        buildWhen: (prev, curr) => prev.preview != curr.preview,
        builder: (context, state) {
          if (state.preview == null) return const SizedBox.shrink();
          return _PaymentDetailsBar(preview: state.preview!);
        },
      ),
    );
  }
}

class _OrderConfirmContent extends StatelessWidget {
  final OrderConfirmState state;

  const _OrderConfirmContent({required this.state});

  @override
  Widget build(BuildContext context) {
    final preview = state.preview!;
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      children: [
        for (int i = 0; i < preview.sellers.length; i++) ...[
          _SellerCard(seller: preview.sellers[i], index: i),
          const SizedBox(height: 12),
        ],
        const SizedBox(height: 4),
        _AddressCard(
          selectedAddress: state.selectedAddress,
          onTap: () async {
            final picked = await showAddressPickerBottomSheet(context, selectedAddress: state.selectedAddress);
            if (picked != null && context.mounted) {
              context.read<OrderConfirmCubit>().selectAddress(picked);
            }
          },
        ),
        if (state.paymentMethods.isNotEmpty) ...[
          const SizedBox(height: 20),
          _PaymentMethodsSection(
            methods: state.paymentMethods,
            selected: state.selectedPaymentMethod,
            onSelected: (method) => context.read<OrderConfirmCubit>().selectPaymentMethod(method),
          ),
        ],
      ],
    );
  }
}

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

  const _PaymentMethodTile({required this.method, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          shadows: const [
            BoxShadow(color: Color(0x14000000), blurRadius: 2, offset: Offset(0, 2)),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          shadows: const [
            BoxShadow(color: Color(0x14000000), blurRadius: 2, offset: Offset(0, 2)),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: SvgPicture.asset(
                selectedAddress == null ? Assets.icons.plusSquare : Assets.icons.map,
                colorFilter: ColorFilter.mode(context.theme.colors.primary, BlendMode.srcIn),
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

class _SellerCard extends StatelessWidget {
  final CheckoutPreviewSeller seller;
  final int index;

  const _SellerCard({required this.seller, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        shadows: const [
          BoxShadow(color: Color(0x14000000), blurRadius: 2, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.storefront_outlined, size: 18, color: context.theme.colors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Store ${index + 1}',
                  style: TextStyle(
                    color: context.theme.colors.textDark,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
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
          _SellerItemStack(items: seller.items),
          if (seller.shipping > 0) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  context.localization.deliveryFee,
                  style: TextStyle(color: context.theme.colors.textLight, fontSize: 12),
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
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _SellerItemStack extends StatelessWidget {
  final List<CheckoutPreviewItem> items;
  static const double _tile = 57;
  static const double _overlap = 4;
  static const double _badge = 17;

  const _SellerItemStack({required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();
    final lastLeft = (items.length - 1) * (_tile + _overlap);
    final width = lastLeft + _tile + (_badge / 2);
    return SizedBox(
      width: width,
      height: 65,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          for (int i = 0; i < items.length; i++)
            Positioned(
              left: i * (_tile + _overlap),
              top: 8,
              child: _ItemTile(item: items[i]),
            ),
          for (int i = 0; i < items.length; i++)
            if (items[i].quantity > 1)
              Positioned(
                left: i * (_tile + _overlap) + _tile - (_badge / 2),
                top: 0,
                child: _QuantityBadge(quantity: items[i].quantity),
              ),
        ],
      ),
    );
  }
}

class _ItemTile extends StatelessWidget {
  final CheckoutPreviewItem item;

  const _ItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final imageUrl = item.product.hoverImage;
    return Container(
      width: 57,
      height: 57,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFE7F2FC)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: imageUrl != null
            ? CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(color: const Color(0xFFF0F0F0)),
                errorWidget: (_, __, ___) => Container(color: const Color(0xFFF0F0F0)),
              )
            : Container(color: const Color(0xFFF0F0F0)),
      ),
    );
  }
}

class _QuantityBadge extends StatelessWidget {
  final int quantity;

  const _QuantityBadge({required this.quantity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 17,
      height: 17,
      alignment: Alignment.center,
      decoration: const ShapeDecoration(color: Color(0xFFE7F2FC), shape: OvalBorder()),
      child: Text(
        'x$quantity',
        style: const TextStyle(
          color: Color(0xFF00569C),
          fontSize: 9,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _PaymentDetailsBar extends StatelessWidget {
  final CheckoutPreview preview;

  const _PaymentDetailsBar({required this.preview});

  @override
  Widget build(BuildContext context) {
    final totalItems = preview.sellers.fold<int>(0, (sum, s) => sum + s.items.fold<int>(0, (a, i) => a + i.quantity));
    final discount = preview.subtotal + preview.totalShipping - preview.grandTotal;
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, bottom: MediaQuery.of(context).padding.bottom + 16),
      child: Container(
        decoration: BoxDecoration(
          color: context.theme.colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 16, offset: Offset(0, -4))],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.localization.paymentDetails,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: context.theme.colors.black),
            ),
            const SizedBox(height: 12),
            _buildDetailRow(context, context.localization.amount, preview.subtotal.manatFormatted),
            _buildDetailRow(
              context,
              context.localization.productCount,
              '$totalItems ${context.localization.piece}',
            ),
            _buildDetailRow(context, context.localization.deliveryFee, preview.totalShipping.manatFormatted),
            _buildDetailRow(context, context.localization.discount, (discount > 0 ? discount : 0.0).manatFormatted),
            _buildDetailRow(
              context,
              context.localization.total,
              preview.grandTotal.manatFormatted,
              isBold: true,
            ),
            const SizedBox(height: 12),
            CustomButton(onPressed: () {}, text: context.localization.formOrder),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value, {bool isBold = false}) {
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
              color: isBold ? context.theme.colors.primary : context.theme.colors.textGray,
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderConfirmLoading extends StatelessWidget {
  const _OrderConfirmLoading();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      children: [
        ShimmerWrapper(
          child: Container(
            height: 60,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 16),
        ShimmerWrapper(
          child: Column(
            children: List.generate(
              3,
              (_) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
