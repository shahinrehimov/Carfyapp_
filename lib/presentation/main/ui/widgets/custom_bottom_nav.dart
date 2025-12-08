import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/localization/languages/languages.dart';
import 'package:flutter/material.dart';

import '../../../../gen/assets.gen.dart';
import '../enum/main_pages.dart';
import 'navbar_item.dart';

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
              text: Languages.of(context)!.mainHome,
              onTap: () {
                onTap(MainPages.home);
              },
              isActive: activePage == MainPages.home,
            ),
            NavBarItem(
              image: Assets.icons.mainMessage,
              text: Languages.of(context)!.mainMessage,
              onTap: () {
                onTap(MainPages.messages);
              },
              isActive: activePage == MainPages.messages,
            ),
            NavBarItem(
              image: Assets.icons.mainFavorite,
              text: Languages.of(context)!.mainFavorite,
              onTap: () {
                onTap(MainPages.favorites);
              },
              isActive: activePage == MainPages.favorites,
            ),
            NavBarItem(
              image: Assets.icons.mainBasket,
              text: Languages.of(context)!.mainBasket,
              onTap: () {
                onTap(MainPages.basket);
              },
              isActive: activePage == MainPages.basket,
            ),
            NavBarItem(
              image: Assets.icons.mainProfile,
              text: Languages.of(context)!.mainProfile,
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
