// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [BasketPage]
class BasketRoute extends PageRouteInfo<void> {
  const BasketRoute({List<PageRouteInfo>? children})
    : super(BasketRoute.name, initialChildren: children);

  static const String name = 'BasketRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const BasketPage();
    },
  );
}

/// generated route for
/// [CompleteEmailRegisterPage]
class CompleteEmailRegisterRoute
    extends PageRouteInfo<CompleteEmailRegisterRouteArgs> {
  CompleteEmailRegisterRoute({
    Key? key,
    required String email,
    List<PageRouteInfo>? children,
  }) : super(
         CompleteEmailRegisterRoute.name,
         args: CompleteEmailRegisterRouteArgs(key: key, email: email),
         initialChildren: children,
       );

  static const String name = 'CompleteEmailRegisterRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CompleteEmailRegisterRouteArgs>();
      return WrappedRoute(
        child: CompleteEmailRegisterPage(key: args.key, email: args.email),
      );
    },
  );
}

class CompleteEmailRegisterRouteArgs {
  const CompleteEmailRegisterRouteArgs({this.key, required this.email});

  final Key? key;

  final String email;

  @override
  String toString() {
    return 'CompleteEmailRegisterRouteArgs{key: $key, email: $email}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CompleteEmailRegisterRouteArgs) return false;
    return key == other.key && email == other.email;
  }

  @override
  int get hashCode => key.hashCode ^ email.hashCode;
}

/// generated route for
/// [CompletePhoneRegisterPage]
class CompletePhoneRegisterRoute
    extends PageRouteInfo<CompletePhoneRegisterRouteArgs> {
  CompletePhoneRegisterRoute({
    Key? key,
    required String phone,
    required String confirmationToken,
    required int otp,
    List<PageRouteInfo>? children,
  }) : super(
         CompletePhoneRegisterRoute.name,
         args: CompletePhoneRegisterRouteArgs(
           key: key,
           phone: phone,
           confirmationToken: confirmationToken,
           otp: otp,
         ),
         initialChildren: children,
       );

  static const String name = 'CompletePhoneRegisterRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CompletePhoneRegisterRouteArgs>();
      return WrappedRoute(
        child: CompletePhoneRegisterPage(
          key: args.key,
          phone: args.phone,
          confirmationToken: args.confirmationToken,
          otp: args.otp,
        ),
      );
    },
  );
}

class CompletePhoneRegisterRouteArgs {
  const CompletePhoneRegisterRouteArgs({
    this.key,
    required this.phone,
    required this.confirmationToken,
    required this.otp,
  });

  final Key? key;

  final String phone;

  final String confirmationToken;

  final int otp;

  @override
  String toString() {
    return 'CompletePhoneRegisterRouteArgs{key: $key, phone: $phone, confirmationToken: $confirmationToken, otp: $otp}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CompletePhoneRegisterRouteArgs) return false;
    return key == other.key &&
        phone == other.phone &&
        confirmationToken == other.confirmationToken &&
        otp == other.otp;
  }

  @override
  int get hashCode =>
      key.hashCode ^ phone.hashCode ^ confirmationToken.hashCode ^ otp.hashCode;
}

/// generated route for
/// [FavoritesPage]
class FavoritesRoute extends PageRouteInfo<void> {
  const FavoritesRoute({List<PageRouteInfo>? children})
    : super(FavoritesRoute.name, initialChildren: children);

  static const String name = 'FavoritesRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FavoritesPage();
    },
  );
}

/// generated route for
/// [ForgotPasswordPage]
class ForgotPasswordRoute extends PageRouteInfo<void> {
  const ForgotPasswordRoute({List<PageRouteInfo>? children})
    : super(ForgotPasswordRoute.name, initialChildren: children);

  static const String name = 'ForgotPasswordRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return WrappedRoute(child: const ForgotPasswordPage());
    },
  );
}

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomePage();
    },
  );
}

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LoginPage();
    },
  );
}

/// generated route for
/// [LoginPhoneVerifyPage]
class LoginPhoneVerifyRoute extends PageRouteInfo<LoginPhoneVerifyRouteArgs> {
  LoginPhoneVerifyRoute({
    Key? key,
    required String phone,
    List<PageRouteInfo>? children,
  }) : super(
         LoginPhoneVerifyRoute.name,
         args: LoginPhoneVerifyRouteArgs(key: key, phone: phone),
         initialChildren: children,
       );

  static const String name = 'LoginPhoneVerifyRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<LoginPhoneVerifyRouteArgs>();
      return WrappedRoute(
        child: LoginPhoneVerifyPage(key: args.key, phone: args.phone),
      );
    },
  );
}

class LoginPhoneVerifyRouteArgs {
  const LoginPhoneVerifyRouteArgs({this.key, required this.phone});

  final Key? key;

  final String phone;

  @override
  String toString() {
    return 'LoginPhoneVerifyRouteArgs{key: $key, phone: $phone}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! LoginPhoneVerifyRouteArgs) return false;
    return key == other.key && phone == other.phone;
  }

  @override
  int get hashCode => key.hashCode ^ phone.hashCode;
}

/// generated route for
/// [MainPage]
class MainRoute extends PageRouteInfo<void> {
  const MainRoute({List<PageRouteInfo>? children})
    : super(MainRoute.name, initialChildren: children);

  static const String name = 'MainRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MainPage();
    },
  );
}

/// generated route for
/// [MessagesPage]
class MessagesRoute extends PageRouteInfo<void> {
  const MessagesRoute({List<PageRouteInfo>? children})
    : super(MessagesRoute.name, initialChildren: children);

  static const String name = 'MessagesRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MessagesPage();
    },
  );
}

/// generated route for
/// [ProfilePage]
class ProfileRoute extends PageRouteInfo<void> {
  const ProfileRoute({List<PageRouteInfo>? children})
    : super(ProfileRoute.name, initialChildren: children);

  static const String name = 'ProfileRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ProfilePage();
    },
  );
}

/// generated route for
/// [RegisterPage]
class RegisterRoute extends PageRouteInfo<void> {
  const RegisterRoute({List<PageRouteInfo>? children})
    : super(RegisterRoute.name, initialChildren: children);

  static const String name = 'RegisterRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const RegisterPage();
    },
  );
}

/// generated route for
/// [RegisterPhoneOtpVerifyPage]
class RegisterPhoneOtpVerifyRoute
    extends PageRouteInfo<RegisterPhoneOtpVerifyRouteArgs> {
  RegisterPhoneOtpVerifyRoute({
    Key? key,
    required String phone,
    List<PageRouteInfo>? children,
  }) : super(
         RegisterPhoneOtpVerifyRoute.name,
         args: RegisterPhoneOtpVerifyRouteArgs(key: key, phone: phone),
         initialChildren: children,
       );

  static const String name = 'RegisterPhoneOtpVerifyRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<RegisterPhoneOtpVerifyRouteArgs>();
      return WrappedRoute(
        child: RegisterPhoneOtpVerifyPage(key: args.key, phone: args.phone),
      );
    },
  );
}

class RegisterPhoneOtpVerifyRouteArgs {
  const RegisterPhoneOtpVerifyRouteArgs({this.key, required this.phone});

  final Key? key;

  final String phone;

  @override
  String toString() {
    return 'RegisterPhoneOtpVerifyRouteArgs{key: $key, phone: $phone}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! RegisterPhoneOtpVerifyRouteArgs) return false;
    return key == other.key && phone == other.phone;
  }

  @override
  int get hashCode => key.hashCode ^ phone.hashCode;
}

/// generated route for
/// [RegisteredSuccessfullyPage]
class RegisteredSuccessfullyRoute extends PageRouteInfo<void> {
  const RegisteredSuccessfullyRoute({List<PageRouteInfo>? children})
    : super(RegisteredSuccessfullyRoute.name, initialChildren: children);

  static const String name = 'RegisteredSuccessfullyRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const RegisteredSuccessfullyPage();
    },
  );
}

/// generated route for
/// [SplashPage]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SplashPage();
    },
  );
}
