import 'package:auto_route/auto_route.dart';

import '../../presentation/splash/splash_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    CustomRoute(path: '/', page: SplashRoute.page, initial: true, transitionsBuilder: TransitionsBuilders.fadeIn),
  ];
}
