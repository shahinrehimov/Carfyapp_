import 'package:cached_network_image/cached_network_image.dart';
import 'package:carfy/domain/entities/products/product_show.dart';
import 'package:carfy/gen/assets.gen.dart';
import 'package:carfy/presentation/product_detail/state/product_detail_cubit.dart';
import 'package:carfy/presentation/product_detail/ui/widget/product_detail_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductImageGallery extends StatelessWidget {
  final ProductShow product;

  const ProductImageGallery({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final images = getAllImages(product);
    if (images.length <= 1) return const SizedBox.shrink();

    return Container(
      height: 54,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border.symmetric(horizontal: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: BlocBuilder<ProductDetailCubit, ProductDetailState>(
        buildWhen: (prev, curr) => prev.selectedImageIndex != curr.selectedImageIndex,
        builder: (context, state) {
          return Row(
            children: [
              // Left arrow
              GestureDetector(
                onTap: state.selectedImageIndex > 0
                    ? () => context.read<ProductDetailCubit>().selectImage(state.selectedImageIndex - 1)
                    : null,
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SvgPicture.asset(Assets.icons.arrowLeftCircle),
                ),
              ),
              // Thumbnails
              Expanded(
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: images.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final isSelected = state.selectedImageIndex == index;
                    return GestureDetector(
                      onTap: () => context.read<ProductDetailCubit>().selectImage(index),
                      child: UnconstrainedBox(
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: ShapeDecoration(
                            image: DecorationImage(image: CachedNetworkImageProvider(images[index]), fit: BoxFit.cover),
                            shape: RoundedRectangleBorder(
                              side: isSelected
                                  ? const BorderSide(
                                      width: 2,
                                      strokeAlign: BorderSide.strokeAlignOutside,
                                      color: Color(0xFFF6683C),
                                    )
                                  : BorderSide.none,
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Right arrow
              GestureDetector(
                onTap: state.selectedImageIndex < images.length - 1
                    ? () => context.read<ProductDetailCubit>().selectImage(state.selectedImageIndex + 1)
                    : null,
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SvgPicture.asset(Assets.icons.arrowRightCircle),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
