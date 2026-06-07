import 'package:cached_network_image/cached_network_image.dart';
import 'package:carfy/common/extensions/price_extension.dart';
import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/widgets/shimmer_wrapper.dart';
import 'package:carfy/domain/entities/basket/basket_product.dart';
import 'package:carfy/gen/assets.gen.dart';
import 'package:carfy/presentation/app/state/basket_manager/basket_manager_cubit.dart';
import 'package:carfy/common/widgets/wishlist_heart_button.dart';
import 'package:carfy/presentation/basket/state/basket_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BasketItem extends StatelessWidget {
  final BasketProduct basketProduct;

  const BasketItem({super.key, required this.basketProduct});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 112,
      width: double.maxFinite,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.only(left: 8, top: 7, bottom: 7, right: 10),
      decoration: BoxDecoration(
        color: context.theme.colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.theme.colors.border2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(8),
            child: CachedNetworkImage(
              imageUrl: basketProduct.product.hoverImage!,
              height: 104,
              width: 104,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Title
                Text(
                  basketProduct.product.title,
                  style: TextStyle(color: context.theme.colors.textDark, fontSize: 14, fontWeight: FontWeight.w400),
                ),
                // Price
                Row(
                  children: [
                    Text(
                      basketProduct.priceFinalInBasket.manatFormatted,
                      style: TextStyle(color: context.theme.colors.primary, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    if (basketProduct.product.hasDiscount) ...[
                      const SizedBox(width: 8),
                      Text(
                        basketProduct.priceInBasket.manatFormatted,
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
                // Quantity
                Container(
                  width: 68,
                  height: 22,
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: context.theme.colors.secondary),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          final cpvUuid = basketProduct.product.seller?.uuid;
                          if (cpvUuid == null || basketProduct.basketQuantity <= 1) return;
                          context.read<BasketCubit>().optimisticDecrement(cpvUuid);
                          context.read<BasketManagerCubit>().decrementQuantity(cpvUuid);
                        },
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: basketProduct.basketQuantity > 1
                                ? context.theme.colors.secondary
                                : context.theme.colors.secondary.withValues(alpha: 0.5),
                          ),
                          child: Center(child: SvgPicture.asset(Assets.icons.minus, width: 7)),
                        ),
                      ),
                      Text(
                        basketProduct.basketQuantity.toString(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: context.theme.colors.textDark,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          final cpvUuid = basketProduct.product.seller?.uuid;
                          if (cpvUuid == null) return;
                          context.read<BasketCubit>().optimisticIncrement(cpvUuid);
                          context.read<BasketManagerCubit>().incrementQuantity(cpvUuid);
                        },
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: context.theme.colors.secondary,
                          ),
                          child: Center(child: SvgPicture.asset(Assets.icons.plus, width: 7)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  final cpvUuid = basketProduct.product.seller?.uuid;
                  if (cpvUuid == null) return;
                  context.read<BasketCubit>().optimisticRemove(cpvUuid);
                  context.read<BasketManagerCubit>().removeFromBasket(cpvUuid);
                },
                behavior: HitTestBehavior.opaque,
                child: Padding(padding: const EdgeInsets.all(5.0), child: SvgPicture.asset(Assets.icons.closeSquare)),
              ),
              const SizedBox(height: 22),
              WishlistHeartButton(cpvUuid: basketProduct.product.seller?.uuid),
            ],
          ),
        ],
      ),
    );
  }
}

class BasketLoadingItem extends StatelessWidget {
  const BasketLoadingItem({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerWrapper(
      child: Container(
        height: 112,
        width: double.maxFinite,
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: context.theme.colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.theme.colors.border2),
        ),
      ),
    );
  }
}
