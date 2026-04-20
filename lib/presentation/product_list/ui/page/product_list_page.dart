import 'package:auto_route/auto_route.dart';
import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/presentation/ads/ui/widget/ads_banner.dart';
import 'package:carfy/presentation/filter/state/filter_cubit.dart';
import 'package:carfy/presentation/product_list/state/product_list_cubit.dart';
import 'package:carfy/presentation/product_list/state/product_list_params_ui.dart';
import 'package:carfy/presentation/product_list/ui/widget/product_list_app_bar.dart';
import 'package:carfy/presentation/product_list/ui/widget/product_list_grid.dart';
import 'package:carfy/presentation/product_list/ui/widget/product_list_header.dart';
import 'package:carfy/presentation/product_list/ui/widget/product_list_sort_filter_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class ProductListPage extends StatefulWidget implements AutoRouteWrapper {
  final ProductListPageParams params;

  const ProductListPage({super.key, required this.params});

  @override
  Widget wrappedRoute(BuildContext context) {
    // Sync FilterCubit with page params
    if (!params.fromFilter) {
      context.read<FilterCubit>().syncFromParams(
        categories: params.categories?.toSet(),
        subCategories: params.subCategories?.toSet(),
      );
    }

    return BlocProvider(
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
  }

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  late final FilterCubit _filterCubit;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _filterCubit = context.read<FilterCubit>();
  }

  @override
  void dispose() {
    _filterCubit.reset();
    super.dispose();
  }

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
          AdsBanner(padding: EdgeInsets.fromLTRB(16, 12, 16, 0), margin: EdgeInsets.only(bottom: 12)),
          ProductListHeader(),
          ProductListSortFilterBar(),
          Expanded(child: ProductListGrid()),
        ],
      ),
    );
  }
}
