import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carfy/common/extensions/price_extension.dart';
import 'package:carfy/common/router/app_router.dart';
import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/common/widgets/custom_app_bar.dart';
import 'package:carfy/common/widgets/custom_button.dart';
import 'package:carfy/common/widgets/dotted_line_painter.dart';
import 'package:carfy/domain/entities/address/address.dart';
import 'package:carfy/domain/entities/orders/checkout_preview.dart';
import 'package:carfy/gen/assets.gen.dart';
import 'package:flutter/material.dart';

@RoutePage()
class OrderSuccessPage extends StatelessWidget {
  final CheckoutPreview preview;
  final Address address;

  const OrderSuccessPage({super.key, required this.preview, required this.address});

  @override
  Widget build(BuildContext context) {
    final allItems = preview.sellers.expand((s) => s.items).toList();
    final totalItems = allItems.fold<int>(0, (sum, i) => sum + i.quantity);
    final discount = preview.subtotal + preview.totalShipping - preview.grandTotal;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: context.theme.colors.bg,
        appBar: CustomAppBar(title: context.localization.orderSuccessTitle, leading: const SizedBox.shrink()),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          children: [
            _SuccessHeaderCard(),
            const SizedBox(height: 16),
            _ProductsSection(items: allItems),
            const SizedBox(height: 16),
            _DeliveryAddressSection(address: address),
            const SizedBox(height: 16),
            _PaymentDetailsCard(
              subtotal: preview.subtotal,
              totalShipping: preview.totalShipping,
              grandTotal: preview.grandTotal,
              discount: discount > 0 ? discount : 0.0,
              totalItems: totalItems,
            ),
            const SizedBox(height: 16),
            CustomButton(
              onPressed: () => context.router.pushAndPopUntil(const MainRoute(), predicate: (_) => false),
              text: context.localization.orderSuccessGoHome,
            ),
          ],
        ),
      ),
    );
  }
}

class _SuccessHeaderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        shadows: const [BoxShadow(color: Color(0x14000000), blurRadius: 2, offset: Offset(0, 2))],
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Assets.images.successfullyRegistered.image(height: 100, fit: BoxFit.fill),
          Text(
            context.localization.orderSuccessTitle,
            style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _ProductsSection extends StatelessWidget {
  final List<CheckoutPreviewItem> items;

  const _ProductsSection({required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.localization.orderSuccessProducts,
          style: const TextStyle(color: Color(0xFF292929), fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        for (int i = 0; i < items.length; i++) ...[
          _ProductRow(item: items[i]),
          if (i != items.length - 1) const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _ProductRow extends StatelessWidget {
  final CheckoutPreviewItem item;

  const _ProductRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final imageUrl = item.product.hoverImage;
    return Container(
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFE7F2FC)),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      padding: const EdgeInsets.all(7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 97,
            height: 97,
            decoration: ShapeDecoration(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
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
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Color(0xFF292929), fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.price.manatFormatted,
                    style: const TextStyle(color: Color(0xFF00569C), fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'x${item.quantity}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.36,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DeliveryAddressSection extends StatelessWidget {
  final Address address;

  const _DeliveryAddressSection({required this.address});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.localization.orderSuccessDeliveryAddress,
          style: const TextStyle(color: Color(0xFF292929), fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(
            '${address.city.title},\n${address.addressLine1}',
            style: const TextStyle(
              color: Color(0xFF292929),
              fontSize: 12,
              fontWeight: FontWeight.w400,
              height: 1.6,
              letterSpacing: 0.36,
            ),
          ),
        ),
      ],
    );
  }
}

class _PaymentDetailsCard extends StatelessWidget {
  final double subtotal;
  final double totalShipping;
  final double grandTotal;
  final double discount;
  final int totalItems;

  const _PaymentDetailsCard({
    required this.subtotal,
    required this.totalShipping,
    required this.grandTotal,
    required this.discount,
    required this.totalItems,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 2, offset: Offset(0, 2))],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.localization.paymentDetails,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: context.theme.colors.black),
          ),
          const SizedBox(height: 12),
          _row(context, context.localization.amount, subtotal.manatFormatted),
          _row(context, context.localization.productCount, '$totalItems ${context.localization.piece}'),
          _row(context, context.localization.deliveryFee, totalShipping.manatFormatted),
          _row(context, context.localization.discount, discount.manatFormatted),
          _row(context, context.localization.total, grandTotal.manatFormatted, isBold: true),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, String label, String value, {bool isBold = false}) {
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
