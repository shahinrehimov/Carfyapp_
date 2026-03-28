import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/domain/entities/products/product_show.dart';
import 'package:carfy/presentation/home/ui/widget/product_item.dart';
import 'package:flutter/material.dart';

class ProductRelatedSection extends StatelessWidget {
  final ProductShow product;

  const ProductRelatedSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.localization.relatedProducts,
            style: TextStyle(color: context.theme.colors.textDark, fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            itemCount: product.relatedProducts.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 179 / 267,
            ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => ProductItem(product: product.relatedProducts[index]),
          ),
        ],
      ),
    );
  }
}
