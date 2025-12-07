import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';

import '../../presentation/auth/login/ui/page/login_page.dart';
import '../../presentation/auth/login/ui/page/login_phone_verify_page.dart';
import '../../presentation/basket/ui/page/basket_page.dart';
import '../../presentation/favorites/ui/page/favorites_page.dart';
import '../../presentation/home/ui/page/home_page.dart';
import '../../presentation/main/ui/page/main_page.dart';
import '../../presentation/messages/ui/page/messages_page.dart';
import '../../presentation/profile/ui/page/profile_page.dart';
import '../../presentation/splash/ui/page/splash_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    CustomRoute(path: '/', page: SplashRoute.page, initial: true, transitionsBuilder: TransitionsBuilders.noTransition),
    CustomRoute(
      page: MainRoute.page,
      transitionsBuilder: TransitionsBuilders.noTransition,
      children: [
        AutoRoute(page: HomeRoute.page, initial: true),
        AutoRoute(page: MessagesRoute.page),
        AutoRoute(page: FavoritesRoute.page),
        AutoRoute(page: BasketRoute.page),
        AutoRoute(page: ProfileRoute.page),
      ],
    ),
    AutoRoute(page: LoginRoute.page),
    AutoRoute(page: LoginPhoneVerifyRoute.page),
  ];
}
