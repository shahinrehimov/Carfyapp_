part of '../page/home_page.dart';

class _GroupsSection extends StatelessWidget {
  const _GroupsSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) =>
          previous.groupsStatus != current.groupsStatus || previous.groups != current.groups,
      builder: (context, state) {
        return state.groupsStatus.maybeWhen(
          success: () => Column(
            children: state.groups.map((group) => _GroupItem(group: group)).toList(),
          ),
          orElse: () => Column(
            children: [
              const SizedBox(height: 12),
              const _GroupProductsLoading(),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}

class _GroupItem extends StatelessWidget {
  final Group group;

  const _GroupItem({required this.group});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Heading(header: group.title, onTap: () {}),
        const SizedBox(height: 12),
        _GroupProductsList(products: group.products),
        const SizedBox(height: 24),
      ],
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
