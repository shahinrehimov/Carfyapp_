part of '../page/home_page.dart';

class _AppBar extends StatelessWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16).copyWith(top: 10),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: BlocBuilder<DefaultAddressCubit, DefaultAddressState>(
                    builder: (context, state) {
                      final address = state.address;
                      if (address == null) return const SizedBox.shrink();
                      return Row(
                        children: [
                          SvgPicture.asset(Assets.icons.locationIcon),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              address.city.title,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: context.theme.colors.white),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                SvgPicture.asset(Assets.icons.logoWhite),
                const Expanded(
                  child: Align(alignment: Alignment.centerRight, child: NotificationIconButton()),
                ),
              ],
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final result = await context.pushRoute<String>(SearchRoute());
                      if (result != null && result.isNotEmpty && context.mounted) {
                        context.pushRoute(ProductListRoute(
                          params: ProductListPageParams(search: result),
                        ));
                      }
                    },
                    child: Hero(
                      tag: 'search_field_home',
                      child: Material(
                        color: Colors.transparent,
                        child: AbsorbPointer(
                          child: CustomTextField(
                            controller: TextEditingController(),
                            fillColor: Colors.white,
                            hint: context.localization.productSearchHint,
                            prefix: UnconstrainedBox(child: SvgPicture.asset(Assets.icons.search, width: 20)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () async {
                    final applied = await FilterBottomSheet.show(context);
                    if (applied == true && context.mounted) {
                      final filterState = context.read<FilterCubit>().state;
                      context.pushRoute(
                        ProductListRoute(
                          params: ProductListPageParams(
                            fromFilter: true,
                            brands: filterState.selectedBrand != null ? [filterState.selectedBrand!.slug] : null,
                            categories: filterState.selectedCategories.isNotEmpty ? filterState.selectedCategories.toList() : null,
                            subCategories: filterState.selectedSubCategories.isNotEmpty ? filterState.selectedSubCategories.toList() : null,
                            cityId: filterState.selectedCityIds.isNotEmpty ? filterState.selectedCityIds.first : null,
                            colors: filterState.selectedColorIds.isNotEmpty ? filterState.selectedColorIds.toList() : null,
                            conditions: filterState.selectedConditionSlugs.isNotEmpty
                                ? filterState.selectedConditionSlugs.toList()
                                : null,
                            minYear: filterState.minYear,
                            maxYear: filterState.maxYear,
                            minPrice: filterState.minPrice != null && filterState.minPrice!.isNotEmpty
                                ? double.tryParse(filterState.minPrice!)
                                : null,
                            maxPrice: filterState.maxPrice != null && filterState.maxPrice!.isNotEmpty
                                ? double.tryParse(filterState.maxPrice!)
                                : null,
                          ),
                        ),
                      );
                    }
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: context.theme.colors.white.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(child: SvgPicture.asset(Assets.icons.filters)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
