import 'package:cached_network_image/cached_network_image.dart';
import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/common/widgets/custom_button.dart';
import 'package:carfy/common/widgets/shimmer_wrapper.dart';
import 'package:carfy/domain/entities/products/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../gen/assets.gen.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 179,
      height: 267,
      decoration: BoxDecoration(
        color: context.theme.colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(width: 1, color: context.theme.colors.border2),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8),
          Center(
            child: CachedNetworkImage(imageUrl: product.product.hoverImage!, height: 118, fit: BoxFit.cover),
          ),
          SizedBox(height: 6),
          Row(
            children: [
              Text(
                '${product.priceFinal.toString()} ₼',
                style: TextStyle(color: context.theme.colors.primary, fontSize: 12, fontWeight: FontWeight.w600),
              ),
              if (product.hasDiscount) ...[
                SizedBox(width: 8),
                Text(
                  '${product.price.toString()} ₼',
                  style: TextStyle(
                    color: context.theme.colors.darkGray,
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: 6),
          Text(
            product.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: context.theme.colors.textDark, fontSize: 10, fontWeight: FontWeight.w400),
          ),
          SizedBox(height: 6),
          Spacer(),
          CustomButton(
            onPressed: () {},
            text: context.localization.addToBasket,
            prefix: SvgPicture.asset(
              Assets.icons.mainBasket,
              width: 18,
              colorFilter: ColorFilter.mode(context.theme.colors.white, BlendMode.srcIn),
            ),
            prefixPadding: 8,
            height: 40,
            fontSize: 12,
          ),
          SizedBox(height: 12),
        ],
      ),
    );
  }
}

class ProductItemLoading extends StatelessWidget {
  const ProductItemLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerWrapper(
      child: Container(
        width: 179,
        height: 267,
        decoration: BoxDecoration(
          color: context.theme.colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(width: 1, color: context.theme.colors.border2),
        ),
      ),
    );
  }
}
