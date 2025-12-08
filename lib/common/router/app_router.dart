import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';

import '../../presentation/auth/forgot_password/ui/page/forgot_password_page.dart';
import '../../presentation/auth/login/ui/page/login_page.dart';
import '../../presentation/auth/login/ui/page/login_phone_verify_page.dart';
import '../../presentation/auth/register/ui/page/complete_email_register_page.dart';
import '../../presentation/auth/register/ui/page/complete_phone_register_page.dart';
import '../../presentation/auth/register/ui/page/register_phone_otp_verify.dart';
import '../../presentation/auth/register/ui/page/register_page.dart';
import '../../presentation/auth/register/ui/page/registered_successfully_page.dart';
import '../../presentation/auth/register/ui/page/verify_email_page.dart';
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

    // Auth
    AutoRoute(page: LoginRoute.page),
    AutoRoute(page: LoginPhoneVerifyRoute.page),
    AutoRoute(page: ForgotPasswordRoute.page),
    AutoRoute(page: RegisterRoute.page),
    AutoRoute(page: RegisterPhoneOtpVerifyRoute.page),
    AutoRoute(page: CompletePhoneRegisterRoute.page),
    AutoRoute(page: CompleteEmailRegisterRoute.page),
    AutoRoute(page: VerifyEmailRoute.page),
    AutoRoute(page: RegisteredSuccessfullyRoute.page),
  ];
}
