import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/gen/assets.gen.dart';
import 'package:carfy/presentation/filter/state/filter_cubit.dart';
import 'package:carfy/presentation/filter/ui/filter_bottom_sheet.dart';
import 'package:carfy/presentation/filter/ui/sort_bottom_sheet.dart';
import 'package:carfy/presentation/product_list/state/product_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductListSortFilterBar extends StatelessWidget {
  const ProductListSortFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          const Divider(height: 1, color: Color(0xFFEDEDED)),
          SizedBox(
            height: 48,
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () async {
                      final listCubit = context.read<ProductListCubit>();
                      final current = listCubit.state;
                      final result = await SortBottomSheet.show(
                        context,
                        currentSort: current.sort,
                        currentSortType: current.sortType,
                      );
                      if (result != null) {
                        listCubit.updateSort(result.sort, result.sortType);
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          context.localization.sorting,
                          style: const TextStyle(
                            color: Color(0xFF5F5F5F),
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        const SizedBox(width: 4),
                        SvgPicture.asset(Assets.icons.list1, width: 24),
                      ],
                    ),
                  ),
                ),
                Container(width: 1, height: 48, color: const Color(0xFFEDEDED)),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () async {
                      final applied = await FilterBottomSheet.show(context);
                      if (applied == true && context.mounted) {
                        final filterState = context.read<FilterCubit>().state;
                        context.read<ProductListCubit>().applyFilters(
                          brands: filterState.selectedBrand != null ? [filterState.selectedBrand!.slug] : null,
                          categories: filterState.selectedCategories.isNotEmpty ? filterState.selectedCategories.toList() : null,
                          subCategories: filterState.selectedSubCategories.isNotEmpty ? filterState.selectedSubCategories.toList() : null,
                          cityId: filterState.selectedCityIds.isNotEmpty ? filterState.selectedCityIds.first : null,
                          colors: filterState.selectedColorSlugs.isNotEmpty ? filterState.selectedColorSlugs.toList() : null,
                          conditions: filterState.selectedConditionSlugs.isNotEmpty ? filterState.selectedConditionSlugs.toList() : null,
                          minYear: filterState.minYear,
                          maxYear: filterState.maxYear,
                          minPrice: filterState.minPrice != null && filterState.minPrice!.isNotEmpty
                              ? double.tryParse(filterState.minPrice!)
                              : null,
                          maxPrice: filterState.maxPrice != null && filterState.maxPrice!.isNotEmpty
                              ? double.tryParse(filterState.maxPrice!)
                              : null,
                        );
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          context.localization.filter,
                          style: const TextStyle(
                            color: Color(0xFF5F5F5F),
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        const SizedBox(width: 4),
                        SvgPicture.asset(Assets.icons.filters, width: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFEDEDED)),
        ],
      ),
    );
  }
}
