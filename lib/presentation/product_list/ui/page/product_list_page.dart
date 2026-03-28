import 'package:auto_route/auto_route.dart';
import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/presentation/product_list/state/product_list_cubit.dart';
import 'package:carfy/presentation/product_list/state/product_list_params_ui.dart';
import 'package:carfy/presentation/product_list/ui/widget/product_list_app_bar.dart';
import 'package:carfy/presentation/product_list/ui/widget/product_list_grid.dart';
import 'package:carfy/presentation/product_list/ui/widget/product_list_header.dart';
import 'package:carfy/presentation/product_list/ui/widget/product_list_sort_filter_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class ProductListPage extends StatelessWidget implements AutoRouteWrapper {
  final ProductListPageParams params;

  const ProductListPage({super.key, required this.params});

  @override
  Widget wrappedRoute(BuildContext context) => BlocProvider(
    create: (_) => ProductListCubit()
      ..init(
        search: params.search,
        categories: params.categories,
        subCategories: params.subCategories,
        brands: params.brands,
        cityId: params.cityId,
        colors: params.colors,
        conditions: params.conditions,
        minYear: params.minYear,
        maxYear: params.maxYear,
        minPrice: params.minPrice,
        maxPrice: params.maxPrice,
      ),
    child: this,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colors.bg,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: ProductListAppBar(),
      ),
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProductListHeader(),
          ProductListSortFilterBar(),
          Expanded(child: ProductListGrid()),
        ],
      ),
    );
  }
}
