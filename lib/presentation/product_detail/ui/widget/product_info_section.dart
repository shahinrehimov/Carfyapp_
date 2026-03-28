import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/domain/entities/products/product_show.dart';
import 'package:flutter/material.dart';

class ProductInfoSection extends StatelessWidget {
  final ProductShow product;

  const ProductInfoSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.title,
            style: TextStyle(color: context.theme.colors.textDark, fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),
          if (product.ratings != null) ...[
            Row(
              children: [
                ...List.generate(5, (index) {
                  return Icon(
                    index < product.ratings!.average.round() ? Icons.star : Icons.star_border,
                    size: 21,
                    color: const Color(0xFFF6683C),
                  );
                }),
                const SizedBox(width: 8),
                Text(
                  '(${product.ratings!.average})',
                  style: TextStyle(color: context.theme.colors.textDark, fontSize: 14, fontWeight: FontWeight.w400),
                ),
                const SizedBox(width: 16),
                // TODO: use message icon
                Icon(Icons.chat_bubble_outline, size: 16, color: context.theme.colors.textDark),
                const SizedBox(width: 4),
                Text(
                  '${product.ratings!.count} ${context.localization.reviews}',
                  style: TextStyle(color: context.theme.colors.textDark, fontSize: 14, fontWeight: FontWeight.w400),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
          if (product.hasDiscount)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFE764C).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // TODO: use coupon/discount icon
                  Icon(Icons.local_offer_outlined, size: 24, color: context.theme.colors.textDark),
                  const SizedBox(width: 8),
                  Text(
                    '${product.discount.toStringAsFixed(0)}% ${context.localization.discount}',
                    style: TextStyle(color: context.theme.colors.black, fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),
          if (product.oemCode != null)
            Text(
              '${context.localization.productCode}: ${product.oemCode}',
              style: TextStyle(color: context.theme.colors.black, fontSize: 14, fontWeight: FontWeight.w300),
            ),
          const SizedBox(height: 16),
          Divider(color: const Color(0xFFE3E3E3), height: 1),
        ],
      ),
    );
  }
}
