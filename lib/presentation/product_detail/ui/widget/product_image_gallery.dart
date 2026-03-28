import 'package:cached_network_image/cached_network_image.dart';
import 'package:carfy/domain/entities/products/product_show.dart';
import 'package:carfy/presentation/product_detail/state/product_detail_cubit.dart';
import 'package:carfy/presentation/product_detail/ui/widget/product_detail_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductImageGallery extends StatelessWidget {
  final ProductShow product;

  const ProductImageGallery({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final images = getAllImages(product);
    if (images.length <= 1) return const SizedBox.shrink();

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(bottom: 16),
      child: SizedBox(
        height: 38,
        child: BlocBuilder<ProductDetailCubit, ProductDetailState>(
          buildWhen: (prev, curr) => prev.selectedImageIndex != curr.selectedImageIndex,
          builder: (context, state) {
            return ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 58),
              itemCount: images.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final isSelected = state.selectedImageIndex == index;
                return GestureDetector(
                  onTap: () => context.read<ProductDetailCubit>().selectImage(index),
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: isSelected ? Border.all(color: const Color(0xFFF6683C), width: 2) : null,
                      image: DecorationImage(image: CachedNetworkImageProvider(images[index]), fit: BoxFit.cover),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
