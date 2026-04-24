import 'package:auto_route/auto_route.dart';
import 'package:carfy/common/router/app_router.dart';
import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/widgets/custom_button.dart';
import 'package:flutter/material.dart';

import 'package:carfy/gen/assets.gen.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';

enum NotLoggedPage { messages, favorites, basket, profile }

class NotLoggedView extends StatelessWidget {
  final NotLoggedPage page;

  const NotLoggedView({super.key, required this.page});

  // $1 is ui, $2 is icon
  (String, String) _getData(BuildContext context) => switch (page) {
    NotLoggedPage.messages => (context.localization.messagesNotLoggedText, Assets.images.messageNotLogged.path),
    NotLoggedPage.favorites => (context.localization.messagesNotLoggedText, Assets.images.favoriteNotLogged.path),
    NotLoggedPage.basket => (context.localization.messagesNotLoggedText, Assets.images.basketNotLogged.path),
    NotLoggedPage.profile => (context.localization.messagesNotLoggedText, Assets.images.profileNotLogged.path),
  };

  @override
  Widget build(BuildContext context) {
    final data = _getData(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(data.$2, height: 168),
        Text(data.$1, style: TextStyle(fontSize: 18, color: context.theme.colors.black)),
        const SizedBox(height: 24),
        CustomButton(onPressed: () => context.pushRoute(const LoginRoute()), text: context.localization.login, width: 268),
        if (page == NotLoggedPage.profile) ...[
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsetsGeometry.symmetric(horizontal: 26),
            child: Row(
              children: [
                Expanded(child: Divider(color: context.theme.colors.divider, thickness: 1)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    context.localization.or,
                    style: TextStyle(fontWeight: FontWeight.w300, color: context.theme.colors.darkGray),
                  ),
                ),
                Expanded(child: Divider(color: context.theme.colors.divider, thickness: 1)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          CustomButton(
            onPressed: () => context.pushRoute(const RegisterRoute()),
            backgroundColor: Colors.transparent,
            color: context.theme.colors.secondary,
            outlineColor: context.theme.colors.secondary,
            text: context.localization.signUp,
            width: 268,
          ),
        ],
      ],
    );
  }
}
