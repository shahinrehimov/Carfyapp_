import 'package:auto_route/auto_route.dart';
import 'package:carfy/common/router/app_router.dart';
import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/common/widgets/custom_app_bar.dart';
import 'package:carfy/common/widgets/custom_text_field.dart';
import 'package:carfy/common/widgets/pagination_scroll_wrapper.dart';
import 'package:carfy/common/widgets/shimmer_wrapper.dart';
import 'package:carfy/domain/entities/products/product.dart';
import 'package:carfy/presentation/home/ui/widget/product_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../gen/assets.gen.dart';
import '../../../categories/ui/widget/category_item.dart';
import '../../state/home_cubit.dart';

part '../widget/app_bar.dart';

part '../widget/categories_section.dart';

part '../widget/group_section.dart';

part '../widget/products_section.dart';

@RoutePage()
class HomePage extends StatelessWidget implements AutoRouteWrapper {
  const HomePage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) => BlocProvider(create: (_) => HomeCubit()..init(), child: this);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colors.bg,
      appBar: CustomAppBar(height: 130, flexibleSpace: const _AppBar()),
      body: PaginationScrollWrapper(
        onLoadMore: () => context.read<HomeCubit>().loadNextProducts(),
        child: Column(
          children: [
            SizedBox(height: 16),
            _Heading(
              header: context.localization.categories,
              onTap: () {
                context.router.push(CategoriesRoute());
              },
            ),
            SizedBox(height: 8),
            _CategoriesSection(),
            SizedBox(height: 24),
            BlocBuilder<HomeCubit, HomeState>(
              buildWhen: (previous, current) => previous.bestSeller != current.bestSeller,
              builder: (context, state) {
                final title = state.bestSeller?.title ?? '';
                return _Heading(header: title, onTap: () {});
              },
            ),
            SizedBox(height: 12),
            _GroupSection(),
            SizedBox(height: 24),
            _Heading(header: context.localization.allProducts, onTap: () {}),
            SizedBox(height: 12),
            _ProductsSection(),
          ],
        ),
      ),
    );
  }
}

class _Heading extends StatelessWidget {
  final String header;
  final VoidCallback onTap;

  const _Heading({required this.header, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text(
            header,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.theme.colors.primary),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onTap,
            child: Row(
              children: [
                Text(
                  context.localization.seeAll,
                  style: TextStyle(color: context.theme.colors.lightGray, fontSize: 12, fontWeight: FontWeight.w300),
                ),
                const SizedBox(width: 2),
                SvgPicture.asset(Assets.icons.chevronRight),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
