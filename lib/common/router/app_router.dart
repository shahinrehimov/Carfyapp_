import 'package:auto_route/auto_route.dart';

import '../../presentation/home/ui/page/home_page.dart';
import '../../presentation/main/ui/page/main_page.dart';
import '../../presentation/splash/ui/page/splash_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    CustomRoute(path: '/', page: SplashRoute.page, initial: true, transitionsBuilder: TransitionsBuilders.noTransition),
    CustomRoute(
      page: MainRoute.page,
      transitionsBuilder: TransitionsBuilders.fadeIn,
      children: [
        AutoRoute(page: HomeRoute.page, initial: true),
        AutoRoute(page: SplashRoute.page),
      ],
    ),
  ];
}
