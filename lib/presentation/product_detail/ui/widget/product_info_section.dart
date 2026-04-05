import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/domain/entities/products/product_show.dart';
import 'package:carfy/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductInfoSection extends StatelessWidget {
  final ProductShow product;

  const ProductInfoSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(top: 20),
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
                      return SvgPicture.asset(
                        Assets.icons.star,
                        width: 21,
                        height: 21,
                        colorFilter: ColorFilter.mode(
                          index < product.ratings!.average.round() ? const Color(0xFFFE764C) : const Color(0xFFDFDFDF),
                          BlendMode.srcIn,
                        ),
                      );
                    }),
                    const SizedBox(width: 8),
                    Text(
                      '(${product.ratings!.average})',
                      style: TextStyle(color: context.theme.colors.textDark, fontSize: 14, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(width: 16),
                    SvgPicture.asset(Assets.icons.comment5),
                    const SizedBox(width: 8),
                    Text(
                      '${product.ratings!.count} ${context.localization.reviews}',
                      style: TextStyle(color: context.theme.colors.textDark, fontSize: 14, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
              if (product.oemCode != null) ...[
                const SizedBox(height: 16),
                Text(
                  '${context.localization.productCode}: ${product.oemCode}',
                  style: TextStyle(color: context.theme.colors.black, fontSize: 14, fontWeight: FontWeight.w300),
                ),
              ],
              const SizedBox(height: 16),
            ],
          ),
        ),
        const Divider(color: Color(0xFFE3E3E3), height: 1),
      ],
    );
  }
}
