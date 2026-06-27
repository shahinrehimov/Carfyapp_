import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carfy/common/extensions/price_extension.dart';
import 'package:carfy/common/router/app_router.dart';
import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/common/widgets/custom_button.dart';
import 'package:carfy/common/widgets/shimmer_wrapper.dart';
import 'package:carfy/domain/entities/products/product.dart';
import 'package:carfy/common/widgets/wishlist_heart_button.dart';
import 'package:carfy/presentation/app/state/basket_manager/basket_manager_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:carfy/gen/assets.gen.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({super.key, required this.product});

  void _navigateToDetail(BuildContext context) {
    final cpvUuid = product.seller?.uuid ?? product.uuid;
    context.pushRoute(ProductDetailRoute(cpvUuid: cpvUuid));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToDetail(context),
      child: Container(
        width: 179,
        height: 267,
        decoration: BoxDecoration(
          color: context.theme.colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(width: 1, color: context.theme.colors.border2),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Stack(
              children: [
                Center(
                  child: CachedNetworkImage(imageUrl: product.hoverImage!, height: 118, fit: BoxFit.cover),
                ),
                const SizedBox(width: double.maxFinite),
                Positioned(right: 10, top: 6, child: WishlistHeartButton(cpvUuid: product.seller?.uuid)),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Text(
                  product.priceFinal.manatFormatted,
                  style: TextStyle(color: context.theme.colors.primary, fontSize: 12, fontWeight: FontWeight.w600),
                ),
                if (product.hasDiscount) ...[
                  const SizedBox(width: 8),
                  Text(
                    product.price.manatFormatted,
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
            const SizedBox(height: 6),
            Text(
              product.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: context.theme.colors.textDark, fontSize: 10, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 6),
            const Spacer(),
            if (product.ratings != null) ...[
              Row(
                children: [
                  ...List.generate(5, (index) {
                    return SvgPicture.asset(
                      Assets.icons.star,
                      width: 12,
                      height: 12,
                      colorFilter: ColorFilter.mode(
                        index < product.ratings!.average.round() ? const Color(0xFFFE764C) : const Color(0xFFDFDFDF),
                        BlendMode.srcIn,
                      ),
                    );
                  }),
                  const SizedBox(width: 6),
                  Text(
                    '(${product.ratings!.count} ${context.localization.ratingLabel})',
                    style: TextStyle(color: context.theme.colors.textDark, fontSize: 10, fontWeight: FontWeight.w300),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
            BlocBuilder<BasketManagerCubit, BasketManagerState>(
              builder: (context, state) {
                final cpvUuid = product.seller?.uuid;
                final isLoading = cpvUuid != null && state.isLoading(cpvUuid);
                return CustomButton(
                  onPressed: isLoading || cpvUuid == null
                      ? () {}
                      : () {
                          context.read<BasketManagerCubit>().addToBasket(cpvUuid);
                        },
                  loading: isLoading,
                  text: context.localization.addToBasket,
                  prefix: isLoading
                      ? null
                      : SvgPicture.asset(
                          Assets.icons.mainBasket,
                          width: 18,
                          colorFilter: ColorFilter.mode(context.theme.colors.white, BlendMode.srcIn),
                        ),
                  prefixPadding: 8,
                  height: 40,
                  fontSize: 12,
                );
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
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
