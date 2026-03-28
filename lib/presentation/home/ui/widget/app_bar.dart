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
                  child: Row(
                    children: [
                      SvgPicture.asset(Assets.icons.locationIcon),
                      const SizedBox(width: 6),
                      Text('Baki', style: TextStyle(color: context.theme.colors.white)),
                    ],
                  ),
                ),
                SvgPicture.asset(Assets.icons.logoWhite),
                Expanded(
                  child: Align(alignment: Alignment.centerRight, child: SvgPicture.asset(Assets.icons.notification)),
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
                            brands: filterState.selectedBrand != null ? [filterState.selectedBrand!.slug] : null,
                            cityId: filterState.selectedCity?.id,
                            colors: filterState.selectedColor != null ? [filterState.selectedColor!.slug] : null,
                            conditions: filterState.selectedCondition != null
                                ? [filterState.selectedCondition!.slug]
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
