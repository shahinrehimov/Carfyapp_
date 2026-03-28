import 'package:auto_route/auto_route.dart';
import 'package:carfy/common/router/app_router.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/common/widgets/custom_text_field.dart';
import 'package:carfy/gen/assets.gen.dart';
import 'package:carfy/presentation/product_list/state/product_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductListAppBar extends StatelessWidget {
  const ProductListAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      toolbarHeight: 60,
      titleSpacing: 16,
      title: Row(
        children: [
          GestureDetector(
            onTap: () => context.router.maybePop(),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                border: Border.all(color: const Color(0xFFD8D7D7)),
              ),
              child: Center(
                child: SvgPicture.asset(Assets.icons.arrowNarrowLeft),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: () async {
                final result = await context.pushRoute<String>(SearchRoute(heroTag: 'search_field_list'));
                if (result != null && result.isNotEmpty && context.mounted) {
                  context.read<ProductListCubit>().init(search: result);
                }
              },
              child: Hero(
                tag: 'search_field_list',
                child: Material(
                  color: Colors.transparent,
                  child: AbsorbPointer(
                    child: CustomTextField(
                      controller: TextEditingController(),
                      hint: context.localization.productSearchHint,
                      prefix: UnconstrainedBox(child: SvgPicture.asset(Assets.icons.search, width: 18)),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
