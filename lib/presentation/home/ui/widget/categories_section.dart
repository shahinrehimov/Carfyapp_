part of '../page/home_page.dart';

class _CategoriesSection extends StatelessWidget {
  const _CategoriesSection();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 83,
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return state.categoriesStatus.maybeWhen(
            success: () => ListView.builder(
              itemCount: state.categories.length,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(left: 16),
              itemBuilder: (context, index) => CategoryItem(category: state.categories[index]),
            ),
            orElse: () => _CategoriesLoading(),
          );
        },
      ),
    );
  }
}

class _CategoriesLoading extends StatelessWidget {
  const _CategoriesLoading();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      scrollDirection: Axis.horizontal,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(left: 16),
      itemBuilder: (context, index) => ShimmerWrapper(
        child: Container(
          width: 124,
          margin: EdgeInsets.only(right: 8),
          decoration: BoxDecoration(color: context.theme.colors.white, borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }
}
