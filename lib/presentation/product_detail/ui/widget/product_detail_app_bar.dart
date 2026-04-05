import 'package:auto_route/auto_route.dart';
import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductDetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProductDetailAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 0.5,
      leading: IconButton(
        onPressed: () => context.router.maybePop(),
        icon: SvgPicture.asset(Assets.icons.arrowNarrowLeft),
      ),
      title: Text(
        context.localization.productDetail,
        style: TextStyle(color: context.theme.colors.black, fontSize: 14, fontWeight: FontWeight.w500),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {},
          icon: SvgPicture.asset(
            Assets.icons.notification,
            colorFilter: ColorFilter.mode(context.theme.colors.primary, BlendMode.srcIn),
          ),
        ),
      ],
    );
  }
}
