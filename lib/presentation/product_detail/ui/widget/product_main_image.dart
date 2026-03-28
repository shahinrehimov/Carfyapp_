import 'package:cached_network_image/cached_network_image.dart';
import 'package:carfy/domain/entities/products/product_show.dart';
import 'package:carfy/gen/assets.gen.dart';
import 'package:carfy/presentation/app/state/wishlist_manager/wishlist_manager_cubit.dart';
import 'package:carfy/presentation/product_detail/state/product_detail_cubit.dart';
import 'package:carfy/presentation/product_detail/ui/widget/product_detail_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductMainImage extends StatelessWidget {
  final ProductShow product;

  const ProductMainImage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final images = getAllImages(product);
    if (images.isEmpty) return const SizedBox(height: 300);

    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          BlocBuilder<ProductDetailCubit, ProductDetailState>(
            buildWhen: (prev, curr) => prev.selectedImageIndex != curr.selectedImageIndex,
            builder: (context, state) {
              final index = state.selectedImageIndex.clamp(0, images.length - 1);
              return SizedBox(
                width: double.infinity,
                height: 300,
                child: CachedNetworkImage(imageUrl: images[index], fit: BoxFit.contain),
              );
            },
          ),
          Positioned(
            right: 16,
            top: 8,
            child: BlocBuilder<WishlistManagerCubit, WishlistManagerState>(
              buildWhen: (prev, curr) {
                final cpvUuid = product.seller?.uuid;
                if (cpvUuid == null) return false;
                return prev.wishlistIds.contains(cpvUuid) != curr.wishlistIds.contains(cpvUuid);
              },
              builder: (context, wishlistState) {
                final cpvUuid = product.seller?.uuid;
                final isWishlisted = cpvUuid != null && wishlistState.wishlistIds.contains(cpvUuid);
                return GestureDetector(
                  onTap: cpvUuid != null ? () => context.read<WishlistManagerCubit>().toggle(cpvUuid) : null,
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: const [BoxShadow(color: Color(0x28000000), blurRadius: 8)],
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        isWishlisted ? Assets.icons.heartFilled : Assets.icons.heart,
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
