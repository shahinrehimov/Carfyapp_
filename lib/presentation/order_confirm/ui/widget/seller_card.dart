import 'package:cached_network_image/cached_network_image.dart';
import 'package:carfy/common/extensions/price_extension.dart';
import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/domain/entities/orders/checkout_preview.dart';
import 'package:flutter/material.dart';

class SellerCard extends StatelessWidget {
  final CheckoutPreviewSeller seller;

  const SellerCard({super.key, required this.seller});

  @override
  Widget build(BuildContext context) {
    final itemsTotal = seller.items.fold<double>(0, (sum, item) => sum + item.price);
    final total = itemsTotal + seller.shipping;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        shadows: const [BoxShadow(color: Color(0x14000000), blurRadius: 2, offset: Offset(0, 2))],
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
                  seller.storeCode,
                  style: TextStyle(color: context.theme.colors.textDark, fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
              Text(
                total.manatFormatted,
                style: TextStyle(color: context.theme.colors.primary, fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (final item in seller.items) ...[_ProductItemRow(item: item), const SizedBox(height: 8)],
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                context.localization.shippingLabel,
                style: TextStyle(color: context.theme.colors.textLight, fontSize: 12),
              ),
              const SizedBox(width: 4),
              Text(
                seller.shipping.manatFormatted,
                style: TextStyle(color: context.theme.colors.textDark, fontSize: 12, fontWeight: FontWeight.w500),
              ),
              const Spacer(),
              Icon(Icons.access_time, size: 14, color: context.theme.colors.textLight),
              const SizedBox(width: 4),
              Text(
                '~${seller.shippingEtaMinutes} ${context.localization.shippingMinutes}',
                style: TextStyle(color: context.theme.colors.textLight, fontSize: 12),
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
                    placeholder: (_, __) => Container(color: const Color(0xFFF0F0F0)),
                    errorWidget: (_, __, ___) => Container(color: const Color(0xFFF0F0F0)),
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
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Color(0xFF242323)),
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
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: context.theme.colors.textDark),
        ),
      ],
    );
  }
}
