import 'package:carfy/common/theme/theme.dart';
import 'package:flutter/material.dart';

import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/gen/assets.gen.dart';
import 'package:carfy/presentation/main/ui/enum/main_pages.dart';
import 'package:carfy/presentation/main/ui/widgets/navbar_item.dart';

class CustomBottomNav extends StatelessWidget {
  const CustomBottomNav({super.key, required this.onTap, required this.activePage});

  final Function(MainPages page) onTap;
  final MainPages activePage;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: context.theme.colors.white,
      elevation: 0,
      child: SizedBox(
        height: 68,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            NavBarItem(
              image: Assets.icons.mainHome,
              text: context.localization.mainHome,
              onTap: () {
                onTap(MainPages.home);
              },
              isActive: activePage == MainPages.home,
            ),
            NavBarItem(
              image: Assets.icons.mainMessage,
              text: context.localization.mainMessage,
              onTap: () {
                onTap(MainPages.messages);
              },
              isActive: activePage == MainPages.messages,
            ),
            NavBarItem(
              image: Assets.icons.mainFavorite,
              text: context.localization.mainFavorite,
              onTap: () {
                onTap(MainPages.favorites);
              },
              isActive: activePage == MainPages.favorites,
            ),
            NavBarItem(
              image: Assets.icons.mainBasket,
              text: context.localization.mainBasket,
              onTap: () {
                onTap(MainPages.basket);
              },
              isActive: activePage == MainPages.basket,
            ),
            NavBarItem(
              image: Assets.icons.mainProfile,
              text: context.localization.mainProfile,
              onTap: () {
                onTap(MainPages.profile);
              },
              isActive: activePage == MainPages.profile,
            ),
          ],
        ),
      ),
    );
  }
}
