import 'package:auto_route/auto_route.dart';
import 'package:carfy/domain/entities/auth/auth_user.dart';
import 'package:carfy/domain/entities/car/user_car.dart';
import 'package:flutter/cupertino.dart';

import 'package:carfy/domain/entities/categories/category.dart';
import 'package:carfy/presentation/auth/forgot_password/ui/page/forgot_password_page.dart';
import 'package:carfy/presentation/auth/login/ui/page/login_page.dart';
import 'package:carfy/presentation/auth/login/ui/page/login_phone_verify_page.dart';
import 'package:carfy/presentation/auth/register/ui/page/complete_email_register_page.dart';
import 'package:carfy/presentation/auth/register/ui/page/complete_phone_register_page.dart';
import 'package:carfy/presentation/auth/register/ui/page/register_phone_otp_verify.dart';
import 'package:carfy/presentation/auth/register/ui/page/register_page.dart';
import 'package:carfy/presentation/auth/register/ui/page/registered_successfully_page.dart';
import 'package:carfy/presentation/auth/register/ui/page/verify_email_page.dart';
import 'package:carfy/presentation/basket/ui/page/basket_page.dart';
import 'package:carfy/presentation/categories/ui/page/category_dialog_page.dart';
import 'package:carfy/presentation/wishlist/ui/page/wishlist_page.dart';
import 'package:carfy/presentation/home/ui/page/home_page.dart';
import 'package:carfy/presentation/main/ui/page/main_page.dart';
import 'package:carfy/presentation/messages/ui/page/messages_page.dart';
import 'package:carfy/presentation/addresses/ui/page/my_addresses_page.dart';
import 'package:carfy/presentation/cars/ui/page/car_form_page.dart';
import 'package:carfy/presentation/map_picker/map_picker_page.dart';
import 'package:carfy/presentation/cars/ui/page/my_cars_page.dart';
import 'package:carfy/presentation/profile/ui/page/profile_page.dart';
import 'package:carfy/presentation/profile/ui/page/profile_update_page.dart';
import 'package:carfy/presentation/sessions/ui/page/sessions_page.dart';
import 'package:carfy/presentation/splash/ui/page/splash_page.dart';

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
        AutoRoute(page: WishlistRoute.page),
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

    AutoRoute(page: MyCarsRoute.page),
    AutoRoute(page: CarFormRoute.page),
    AutoRoute(page: MyAddressesRoute.page),
    AutoRoute(page: MapPickerRoute.page),
    AutoRoute(page: ProfileUpdateRoute.page),
    AutoRoute(page: SessionsRoute.page),

    AutoRoute(
      page: CategoryDialogRoute.page,
      fullscreenDialog: true,
      children: [
        AutoRoute(initial: true, page: CategoriesRoute.page),
        AutoRoute(page: SubCategoriesRoute.page),
      ],
    ),
  ];
}
