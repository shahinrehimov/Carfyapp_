import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/common/widgets/pagination_scroll_wrapper.dart';
import 'package:carfy/presentation/home/ui/widget/product_item.dart';
import 'package:carfy/presentation/product_list/state/product_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductListGrid extends StatelessWidget {
  const ProductListGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductListCubit, ProductListState>(
      builder: (context, state) {
        final isLoading = state.status.maybeWhen(loading: () => true, orElse: () => false);
        final isPaginationLoading = state.status.maybeWhen(paginationLoading: () => true, orElse: () => false);

        if (isLoading) return const ProductListLoading();

        if (state.products.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.search_off_rounded, size: 64, color: context.theme.colors.textLight),
                const SizedBox(height: 16),
                Text(
                  context.localization.productsEmpty,
                  style: TextStyle(fontSize: 18, color: context.theme.colors.black),
                ),
                const SizedBox(height: 8),
                Text(
                  context.localization.productsEmptyDescription,
                  style: TextStyle(fontSize: 14, color: context.theme.colors.textLight),
                ),
              ],
            ),
          );
        }

        return PaginationScrollWrapper(
          onLoadMore: () => context.read<ProductListCubit>().loadNextPage(),
          child: Column(
            children: [
              GridView.builder(
                itemCount: state.products.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 179 / 267,
                ),
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) => ProductItem(product: state.products[index]),
              ),
              if (isPaginationLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CircularProgressIndicator.adaptive()),
                ),
            ],
          ),
        );
      },
    );
  }
}

class ProductListLoading extends StatelessWidget {
  const ProductListLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: 6,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 179 / 267,
      ),
      padding: const EdgeInsets.all(16),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => const ProductItemLoading(),
    );
  }
}
