import 'package:cached_network_image/cached_network_image.dart';
import 'package:carfy/common/widgets/wishlist_heart_button.dart';
import 'package:carfy/domain/entities/products/product_show.dart';
import 'package:carfy/presentation/product_detail/state/product_detail_cubit.dart';
import 'package:carfy/presentation/product_detail/ui/widget/product_detail_helpers.dart';
import 'package:carfy/presentation/product_detail/ui/widget/product_image_fullscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductMainImage extends StatefulWidget {
  final ProductShow product;

  const ProductMainImage({super.key, required this.product});

  @override
  State<ProductMainImage> createState() => _ProductMainImageState();
}

class _ProductMainImageState extends State<ProductMainImage> {
  late final List<String> _images;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _images = getAllImages(widget.product);
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_images.isEmpty) return const SizedBox(height: 300);

    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          BlocListener<ProductDetailCubit, ProductDetailState>(
            listenWhen: (prev, curr) => prev.selectedImageIndex != curr.selectedImageIndex,
            listener: (context, state) {
              final target = state.selectedImageIndex.clamp(0, _images.length - 1);
              if (_pageController.hasClients &&
                  _pageController.page?.round() != target) {
                _pageController.animateToPage(
                  target,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                );
              }
            },
            child: SizedBox(
              height: 300,
              child: PageView.builder(
                controller: _pageController,
                itemCount: _images.length,
                onPageChanged: (index) =>
                    context.read<ProductDetailCubit>().selectImage(index),
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () => showFullscreenImages(context, _images, index),
                  child: CachedNetworkImage(
                    imageUrl: _images[index],
                    fit: BoxFit.contain,
                    width: double.infinity,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 16,
            top: 8,
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [BoxShadow(color: Color(0x28000000), blurRadius: 8)],
              ),
              child: Center(child: WishlistHeartButton(cpvUuid: widget.product.seller?.uuid)),
            ),
          ),
        ],
      ),
    );
  }
}
