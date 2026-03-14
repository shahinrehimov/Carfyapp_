import 'package:auto_route/auto_route.dart';
import 'package:carfy/domain/entities/categories/category.dart';
import 'package:carfy/presentation/categories/state/category_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carfy/common/router/app_router.dart';
import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/common/widgets/custom_app_bar.dart';
import 'package:carfy/common/widgets/shimmer_wrapper.dart';
import 'package:carfy/gen/assets.gen.dart';
import 'package:carfy/presentation/categories/ui/widget/category_item.dart';
import 'package:flutter_svg/flutter_svg.dart';

@RoutePage()
class CategoryDialogPage extends StatelessWidget {
  const CategoryDialogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => CategoryCubit()..init(), child: const AutoRouter());
  }
}

@RoutePage()
class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colors.white,
      appBar: CustomAppBarWhite(title: context.localization.categories),
      body: BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, state) {
          return state.categoriesStatus.maybeWhen(
            success: () => GridView.builder(
              itemCount: state.categories.length,
              padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(top: 20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 181 / 104,
              ),
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  context.router.push(SubCategoriesRoute(category: state.categories[index]));
                },
                child: CategoryItem(category: state.categories[index]),
              ),
            ),
            orElse: () => const _CategoriesLoading(),
          );
        },
      ),
    );
  }
}

@RoutePage()
class SubCategoriesPage extends StatelessWidget {
  final Category category;

  const SubCategoriesPage({required this.category, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colors.white,
      appBar: CustomAppBarWhite(title: category.title),
      body: ListView.builder(
        itemCount: category.subs.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) => _SubCategoryItem(subCategory: category.subs[index]),
      ),
    );
  }
}

class _SubCategoryItem extends StatelessWidget {
  final SubCategory subCategory;

  const _SubCategoryItem({required this.subCategory});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.router.root.pop();
      },
      child: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Text(subCategory.title, style: TextStyle(color: context.theme.colors.textDark, fontSize: 14)),
              ),
              SvgPicture.asset(Assets.icons.chevronRight, width: 26),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(thickness: 1, height: 1),
        ],
      ),
    );
  }
}

class _CategoriesLoading extends StatelessWidget {
  const _CategoriesLoading();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: 5,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 181 / 104,
      ),
      itemBuilder: (context, index) => ShimmerWrapper(
        child: Container(
          width: 124,
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(color: context.theme.colors.white, borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }
}
