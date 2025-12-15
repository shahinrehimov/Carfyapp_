import 'package:auto_route/auto_route.dart';
import 'package:carfy/common/router/app_router.dart';
import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/common/widgets/custom_app_bar.dart';
import 'package:carfy/common/widgets/custom_text_field.dart';
import 'package:carfy/common/widgets/shimmer_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../gen/assets.gen.dart';
import '../../../categories/ui/widget/category_item.dart';
import '../../state/home_cubit.dart';

part '../widget/app_bar.dart';

part '../widget/categories_section.dart';

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
      body: Column(
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
        ],
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
