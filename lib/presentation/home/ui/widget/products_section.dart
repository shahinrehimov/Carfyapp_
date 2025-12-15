part of '../page/home_page.dart';

class _ProductsSection extends StatelessWidget {
  const _ProductsSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return state.productsStatus.maybeWhen(
          success: () => _ProductsGrid(products: state.products),
          paginationLoading: () => _ProductsGrid(products: state.products, isLoadingMore: true),
          orElse: () => _ProductsLoading(),
        );
      },
    );
  }
}

class _ProductsGrid extends StatelessWidget {
  final List<Product> products;
  final bool isLoadingMore;

  const _ProductsGrid({required this.products, this.isLoadingMore = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GridView.builder(
          itemCount: products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 179 / 267,
          ),
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 16),
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => ProductItem(product: products[index]),
        ),
        if (isLoadingMore)
          Padding(padding: const EdgeInsets.symmetric(vertical: 16), child: CircularProgressIndicator.adaptive()),
      ],
    );
  }
}

class _ProductsLoading extends StatelessWidget {
  const _ProductsLoading();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 179 / 267,
      ),
      itemCount: 10,
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: 16),
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => ProductItemLoading(),
    );
  }
}
