import 'package:auto_route/auto_route.dart';
import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/domain/entities/products/product_show.dart';
import 'package:carfy/domain/params/product/product_show_params.dart';
import 'package:carfy/presentation/product_detail/state/product_detail_cubit.dart';
import 'package:carfy/presentation/product_detail/ui/widget/product_bottom_bar.dart';
import 'package:carfy/presentation/product_detail/ui/widget/product_contact_section.dart';
import 'package:carfy/presentation/product_detail/ui/widget/product_description_section.dart';
import 'package:carfy/presentation/product_detail/ui/widget/product_detail_app_bar.dart';
import 'package:carfy/presentation/product_detail/ui/widget/product_detail_loading.dart';
import 'package:carfy/presentation/product_detail/ui/widget/product_details_table.dart';
import 'package:carfy/presentation/product_detail/ui/widget/product_image_gallery.dart';
import 'package:carfy/presentation/product_detail/ui/widget/product_main_image.dart';
import 'package:carfy/presentation/product_detail/ui/widget/product_info_section.dart';
import 'package:carfy/presentation/product_detail/ui/widget/product_related_section.dart';
import 'package:carfy/presentation/product_detail/ui/widget/product_reviews_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class ProductDetailPage extends StatelessWidget implements AutoRouteWrapper {
  final String? parentSlug;
  final String subSlug;
  final String productSlug;
  final String? variant;
  final String? seller;

  const ProductDetailPage({
    super.key,
    this.parentSlug,
    required this.subSlug,
    required this.productSlug,
    this.variant,
    this.seller,
  });

  @override
  Widget wrappedRoute(BuildContext context) => BlocProvider(
    create: (_) => ProductDetailCubit()
      ..init(
        ProductShowParams(
          parentSlug: parentSlug,
          subSlug: subSlug,
          productSlug: productSlug,
          variant: variant,
          seller: seller,
          otherSellers: true,
          withRelated: true,
        ),
      ),
    child: this,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colors.bg,
      appBar: const ProductDetailAppBar(),
      body: BlocBuilder<ProductDetailCubit, ProductDetailState>(
        builder: (context, state) {
          return state.status.maybeWhen(
            success: () => _ProductDetailBody(product: state.product!),
            loading: () => const ProductDetailLoading(),
            orElse: () => const ProductDetailLoading(),
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<ProductDetailCubit, ProductDetailState>(
        builder: (context, state) {
          if (state.product == null) return const SizedBox.shrink();
          return ProductBottomBar(product: state.product!);
        },
      ),
    );
  }
}

class _ProductDetailBody extends StatelessWidget {
  final ProductShow product;

  const _ProductDetailBody({required this.product});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: ProductMainImage(product: product)),
        SliverToBoxAdapter(child: ProductImageGallery(product: product)),
        SliverToBoxAdapter(child: ProductInfoSection(product: product)),
        SliverToBoxAdapter(child: ProductDetailsTable(product: product)),
        if (product.product?.descriptionShort != null)
          SliverToBoxAdapter(child: ProductDescriptionSection(description: product.product!.descriptionShort!)),
        const SliverToBoxAdapter(child: ProductContactSection()),
        const SliverToBoxAdapter(child: ProductReviewsSection()),
        if (product.relatedProducts.isNotEmpty)
          SliverToBoxAdapter(child: ProductRelatedSection(product: product)),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
      ],
    );
  }
}
