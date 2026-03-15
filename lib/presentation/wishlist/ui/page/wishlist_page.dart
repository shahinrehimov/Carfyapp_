import 'package:auto_route/auto_route.dart';
import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/common/widgets/custom_app_bar.dart';
import 'package:carfy/common/widgets/pagination_scroll_wrapper.dart';
import 'package:carfy/common/widgets/pull_to_refresh_wrapper.dart';
import 'package:carfy/domain/entities/products/product.dart';
import 'package:carfy/gen/assets.gen.dart';
import 'package:carfy/presentation/home/ui/widget/product_item.dart';
import 'package:carfy/presentation/wishlist/state/wishlist_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

@RoutePage()
class WishlistPage extends StatelessWidget implements AutoRouteWrapper {
  const WishlistPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) => BlocProvider(create: (_) => WishlistCubit()..init(), child: this);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colors.bg,
      appBar: CustomAppBar(
        title: context.localization.mainFavorite,
        actions: [IconButton(onPressed: () {}, icon: SvgPicture.asset(Assets.icons.notification))],
      ),
      body: BlocBuilder<WishlistCubit, WishlistState>(
        builder: (context, state) {
          final isEmpty = state.status.maybeWhen(success: () => state.products.isEmpty, orElse: () => false);
          if (isEmpty) return const _WishlistEmpty();

          return PullToRefreshWrapper(
            onRefresh: () async {
              await context.read<WishlistCubit>().refresh();
            },
            child: PaginationScrollWrapper(
              onLoadMore: () => context.read<WishlistCubit>().loadNextPage(),
              child: state.status.maybeWhen(
                success: () => _WishlistGrid(products: state.products),
                paginationLoading: () => _WishlistGrid(products: state.products, isLoadingMore: true),
                orElse: () => const _WishlistLoading(),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _WishlistGrid extends StatelessWidget {
  final List<Product> products;
  final bool isLoadingMore;

  const _WishlistGrid({required this.products, this.isLoadingMore = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        GridView.builder(
          itemCount: products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 179 / 267,
          ),
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => ProductItem(product: products[index]),
        ),
        if (isLoadingMore)
          const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: CircularProgressIndicator.adaptive()),
      ],
    );
  }
}

class _WishlistEmpty extends StatelessWidget {
  const _WishlistEmpty();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(Assets.images.favoriteNotLogged.path, height: 168),
          const SizedBox(height: 16),
          Text(
            context.localization.wishlistEmpty,
            style: TextStyle(fontSize: 18, color: context.theme.colors.black),
          ),
        ],
      ),
    );
  }
}

class _WishlistLoading extends StatelessWidget {
  const _WishlistLoading();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 179 / 267,
        ),
        itemCount: 10,
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => const ProductItemLoading(),
      ),
    );
  }
}
