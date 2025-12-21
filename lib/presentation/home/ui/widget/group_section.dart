part of '../page/home_page.dart';

class _GroupSection extends StatelessWidget {
  const _GroupSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) => previous.bestSellerStatus != current.bestSellerStatus,
      builder: (context, state) {
        return state.bestSellerStatus.maybeWhen(
          success: () => _GroupProductsList(products: state.bestSeller!.products),
          orElse: () => const _GroupProductsLoading(),
        );
      },
    );
  }
}

class _GroupProductsList extends StatelessWidget {
  final List<Product> products;

  const _GroupProductsList({required this.products});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 267,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: products.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) => ProductItem(product: products[index]),
      ),
    );
  }
}

class _GroupProductsLoading extends StatelessWidget {
  const _GroupProductsLoading();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 267,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 5,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) => const ProductItemLoading(),
      ),
    );
  }
}
