import 'package:auto_route/auto_route.dart';
import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/widgets/custom_app_bar.dart';
import 'package:carfy/common/widgets/state_status_toast.dart';
import 'package:carfy/domain/entities/products/product.dart';
import 'package:carfy/presentation/group_products/state/group_products_cubit.dart';
import 'package:carfy/presentation/home/ui/widget/product_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class GroupProductsPage extends StatelessWidget implements AutoRouteWrapper {
  final String slug;
  final String title;

  const GroupProductsPage({super.key, required this.slug, required this.title});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(create: (_) => GroupProductsCubit()..load(slug), child: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colors.bg,
      appBar: CustomAppBar(title: title),
      body: BlocConsumer<GroupProductsCubit, GroupProductsState>(
        listenWhen: (prev, curr) => prev.status != curr.status,
        listener: (context, state) => showStateStatusToast(context, state.status),
        builder: (context, state) {
          return state.status.maybeWhen(
            success: () => _Grid(products: state.products),
            orElse: () => const _Loading(),
          );
        },
      ),
    );
  }
}

class _Grid extends StatelessWidget {
  final List<Product> products;

  const _Grid({required this.products});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 179 / 267,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      itemBuilder: (context, index) => ProductItem(product: products[index]),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 179 / 267,
      ),
      itemCount: 10,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => const ProductItemLoading(),
    );
  }
}
