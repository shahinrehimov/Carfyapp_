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
      return WrappedRoute(child: const BasketPage());
    },
  );
}

/// generated route for
/// [CarFormPage]
class CarFormRoute extends PageRouteInfo<CarFormRouteArgs> {
  CarFormRoute({Key? key, UserCar? car, List<PageRouteInfo>? children})
    : super(
        CarFormRoute.name,
        args: CarFormRouteArgs(key: key, car: car),
        initialChildren: children,
      );

  static const String name = 'CarFormRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CarFormRouteArgs>(
        orElse: () => const CarFormRouteArgs(),
      );
      return WrappedRoute(
        child: CarFormPage(key: args.key, car: args.car),
      );
    },
  );
}

class CarFormRouteArgs {
  const CarFormRouteArgs({this.key, this.car});

  final Key? key;

  final UserCar? car;

  @override
  String toString() {
    return 'CarFormRouteArgs{key: $key, car: $car}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CarFormRouteArgs) return false;
    return key == other.key && car == other.car;
  }

  @override
  int get hashCode => key.hashCode ^ car.hashCode;
}

/// generated route for
/// [CategoriesPage]
class CategoriesRoute extends PageRouteInfo<void> {
  const CategoriesRoute({List<PageRouteInfo>? children})
    : super(CategoriesRoute.name, initialChildren: children);

  static const String name = 'CategoriesRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CategoriesPage();
    },
  );
}

/// generated route for
/// [CategoryDialogPage]
class CategoryDialogRoute extends PageRouteInfo<void> {
  const CategoryDialogRoute({List<PageRouteInfo>? children})
    : super(CategoryDialogRoute.name, initialChildren: children);

  static const String name = 'CategoryDialogRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CategoryDialogPage();
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
/// [ContactUsPage]
class ContactUsRoute extends PageRouteInfo<void> {
  const ContactUsRoute({List<PageRouteInfo>? children})
    : super(ContactUsRoute.name, initialChildren: children);

  static const String name = 'ContactUsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return WrappedRoute(child: const ContactUsPage());
    },
  );
}

/// generated route for
/// [ForceUpdatePage]
class ForceUpdateRoute extends PageRouteInfo<void> {
  const ForceUpdateRoute({List<PageRouteInfo>? children})
    : super(ForceUpdateRoute.name, initialChildren: children);

  static const String name = 'ForceUpdateRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ForceUpdatePage();
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
/// [GroupProductsPage]
class GroupProductsRoute extends PageRouteInfo<GroupProductsRouteArgs> {
  GroupProductsRoute({
    Key? key,
    required String slug,
    required String title,
    List<PageRouteInfo>? children,
  }) : super(
         GroupProductsRoute.name,
         args: GroupProductsRouteArgs(key: key, slug: slug, title: title),
         initialChildren: children,
       );

  static const String name = 'GroupProductsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<GroupProductsRouteArgs>();
      return WrappedRoute(
        child: GroupProductsPage(
          key: args.key,
          slug: args.slug,
          title: args.title,
        ),
      );
    },
  );
}

class GroupProductsRouteArgs {
  const GroupProductsRouteArgs({
    this.key,
    required this.slug,
    required this.title,
  });

  final Key? key;

  final String slug;

  final String title;

  @override
  String toString() {
    return 'GroupProductsRouteArgs{key: $key, slug: $slug, title: $title}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! GroupProductsRouteArgs) return false;
    return key == other.key && slug == other.slug && title == other.title;
  }

  @override
  int get hashCode => key.hashCode ^ slug.hashCode ^ title.hashCode;
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
      return WrappedRoute(child: const HomePage());
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
/// [MapPickerPage]
class MapPickerRoute extends PageRouteInfo<MapPickerRouteArgs> {
  MapPickerRoute({
    Key? key,
    double? initialLatitude,
    double? initialLongitude,
    List<PageRouteInfo>? children,
  }) : super(
         MapPickerRoute.name,
         args: MapPickerRouteArgs(
           key: key,
           initialLatitude: initialLatitude,
           initialLongitude: initialLongitude,
         ),
         initialChildren: children,
       );

  static const String name = 'MapPickerRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<MapPickerRouteArgs>(
        orElse: () => const MapPickerRouteArgs(),
      );
      return WrappedRoute(
        child: MapPickerPage(
          key: args.key,
          initialLatitude: args.initialLatitude,
          initialLongitude: args.initialLongitude,
        ),
      );
    },
  );
}

class MapPickerRouteArgs {
  const MapPickerRouteArgs({
    this.key,
    this.initialLatitude,
    this.initialLongitude,
  });

  final Key? key;

  final double? initialLatitude;

  final double? initialLongitude;

  @override
  String toString() {
    return 'MapPickerRouteArgs{key: $key, initialLatitude: $initialLatitude, initialLongitude: $initialLongitude}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MapPickerRouteArgs) return false;
    return key == other.key &&
        initialLatitude == other.initialLatitude &&
        initialLongitude == other.initialLongitude;
  }

  @override
  int get hashCode =>
      key.hashCode ^ initialLatitude.hashCode ^ initialLongitude.hashCode;
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
/// [MyAddressesPage]
class MyAddressesRoute extends PageRouteInfo<MyAddressesRouteArgs> {
  MyAddressesRoute({
    Key? key,
    bool openAddForm = false,
    List<PageRouteInfo>? children,
  }) : super(
         MyAddressesRoute.name,
         args: MyAddressesRouteArgs(key: key, openAddForm: openAddForm),
         initialChildren: children,
       );

  static const String name = 'MyAddressesRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<MyAddressesRouteArgs>(
        orElse: () => const MyAddressesRouteArgs(),
      );
      return WrappedRoute(
        child: MyAddressesPage(key: args.key, openAddForm: args.openAddForm),
      );
    },
  );
}

class MyAddressesRouteArgs {
  const MyAddressesRouteArgs({this.key, this.openAddForm = false});

  final Key? key;

  final bool openAddForm;

  @override
  String toString() {
    return 'MyAddressesRouteArgs{key: $key, openAddForm: $openAddForm}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MyAddressesRouteArgs) return false;
    return key == other.key && openAddForm == other.openAddForm;
  }

  @override
  int get hashCode => key.hashCode ^ openAddForm.hashCode;
}

/// generated route for
/// [MyCarsPage]
class MyCarsRoute extends PageRouteInfo<void> {
  const MyCarsRoute({List<PageRouteInfo>? children})
    : super(MyCarsRoute.name, initialChildren: children);

  static const String name = 'MyCarsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return WrappedRoute(child: const MyCarsPage());
    },
  );
}

/// generated route for
/// [NotificationsPage]
class NotificationsRoute extends PageRouteInfo<void> {
  const NotificationsRoute({List<PageRouteInfo>? children})
    : super(NotificationsRoute.name, initialChildren: children);

  static const String name = 'NotificationsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return WrappedRoute(child: const NotificationsPage());
    },
  );
}

/// generated route for
/// [OrderConfirmPage]
class OrderConfirmRoute extends PageRouteInfo<void> {
  const OrderConfirmRoute({List<PageRouteInfo>? children})
    : super(OrderConfirmRoute.name, initialChildren: children);

  static const String name = 'OrderConfirmRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return WrappedRoute(child: const OrderConfirmPage());
    },
  );
}

/// generated route for
/// [OrderDetailPage]
class OrderDetailRoute extends PageRouteInfo<OrderDetailRouteArgs> {
  OrderDetailRoute({
    Key? key,
    required int orderId,
    List<PageRouteInfo>? children,
  }) : super(
         OrderDetailRoute.name,
         args: OrderDetailRouteArgs(key: key, orderId: orderId),
         initialChildren: children,
       );

  static const String name = 'OrderDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OrderDetailRouteArgs>();
      return WrappedRoute(
        child: OrderDetailPage(key: args.key, orderId: args.orderId),
      );
    },
  );
}

class OrderDetailRouteArgs {
  const OrderDetailRouteArgs({this.key, required this.orderId});

  final Key? key;

  final int orderId;

  @override
  String toString() {
    return 'OrderDetailRouteArgs{key: $key, orderId: $orderId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! OrderDetailRouteArgs) return false;
    return key == other.key && orderId == other.orderId;
  }

  @override
  int get hashCode => key.hashCode ^ orderId.hashCode;
}

/// generated route for
/// [OrderSuccessPage]
class OrderSuccessRoute extends PageRouteInfo<OrderSuccessRouteArgs> {
  OrderSuccessRoute({
    Key? key,
    required CheckoutPreview preview,
    required Address address,
    List<PageRouteInfo>? children,
  }) : super(
         OrderSuccessRoute.name,
         args: OrderSuccessRouteArgs(
           key: key,
           preview: preview,
           address: address,
         ),
         initialChildren: children,
       );

  static const String name = 'OrderSuccessRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OrderSuccessRouteArgs>();
      return OrderSuccessPage(
        key: args.key,
        preview: args.preview,
        address: args.address,
      );
    },
  );
}

class OrderSuccessRouteArgs {
  const OrderSuccessRouteArgs({
    this.key,
    required this.preview,
    required this.address,
  });

  final Key? key;

  final CheckoutPreview preview;

  final Address address;

  @override
  String toString() {
    return 'OrderSuccessRouteArgs{key: $key, preview: $preview, address: $address}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! OrderSuccessRouteArgs) return false;
    return key == other.key &&
        preview == other.preview &&
        address == other.address;
  }

  @override
  int get hashCode => key.hashCode ^ preview.hashCode ^ address.hashCode;
}

/// generated route for
/// [OrdersPage]
class OrdersRoute extends PageRouteInfo<void> {
  const OrdersRoute({List<PageRouteInfo>? children})
    : super(OrdersRoute.name, initialChildren: children);

  static const String name = 'OrdersRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return WrappedRoute(child: const OrdersPage());
    },
  );
}

/// generated route for
/// [PaymentWebviewPage]
class PaymentWebviewRoute extends PageRouteInfo<PaymentWebviewRouteArgs> {
  PaymentWebviewRoute({
    Key? key,
    required String redirectUrl,
    List<PageRouteInfo>? children,
  }) : super(
         PaymentWebviewRoute.name,
         args: PaymentWebviewRouteArgs(key: key, redirectUrl: redirectUrl),
         initialChildren: children,
       );

  static const String name = 'PaymentWebviewRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PaymentWebviewRouteArgs>();
      return WrappedRoute(
        child: PaymentWebviewPage(key: args.key, redirectUrl: args.redirectUrl),
      );
    },
  );
}

class PaymentWebviewRouteArgs {
  const PaymentWebviewRouteArgs({this.key, required this.redirectUrl});

  final Key? key;

  final String redirectUrl;

  @override
  String toString() {
    return 'PaymentWebviewRouteArgs{key: $key, redirectUrl: $redirectUrl}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PaymentWebviewRouteArgs) return false;
    return key == other.key && redirectUrl == other.redirectUrl;
  }

  @override
  int get hashCode => key.hashCode ^ redirectUrl.hashCode;
}

/// generated route for
/// [ProductDetailPage]
class ProductDetailRoute extends PageRouteInfo<ProductDetailRouteArgs> {
  ProductDetailRoute({
    Key? key,
    required String cpvUuid,
    List<PageRouteInfo>? children,
  }) : super(
         ProductDetailRoute.name,
         args: ProductDetailRouteArgs(key: key, cpvUuid: cpvUuid),
         initialChildren: children,
       );

  static const String name = 'ProductDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ProductDetailRouteArgs>();
      return WrappedRoute(
        child: ProductDetailPage(key: args.key, cpvUuid: args.cpvUuid),
      );
    },
  );
}

class ProductDetailRouteArgs {
  const ProductDetailRouteArgs({this.key, required this.cpvUuid});

  final Key? key;

  final String cpvUuid;

  @override
  String toString() {
    return 'ProductDetailRouteArgs{key: $key, cpvUuid: $cpvUuid}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ProductDetailRouteArgs) return false;
    return key == other.key && cpvUuid == other.cpvUuid;
  }

  @override
  int get hashCode => key.hashCode ^ cpvUuid.hashCode;
}

/// generated route for
/// [ProductListPage]
class ProductListRoute extends PageRouteInfo<ProductListRouteArgs> {
  ProductListRoute({
    Key? key,
    required ProductListPageParams params,
    List<PageRouteInfo>? children,
  }) : super(
         ProductListRoute.name,
         args: ProductListRouteArgs(key: key, params: params),
         initialChildren: children,
       );

  static const String name = 'ProductListRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ProductListRouteArgs>();
      return WrappedRoute(
        child: ProductListPage(key: args.key, params: args.params),
      );
    },
  );
}

class ProductListRouteArgs {
  const ProductListRouteArgs({this.key, required this.params});

  final Key? key;

  final ProductListPageParams params;

  @override
  String toString() {
    return 'ProductListRouteArgs{key: $key, params: $params}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ProductListRouteArgs) return false;
    return key == other.key && params == other.params;
  }

  @override
  int get hashCode => key.hashCode ^ params.hashCode;
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
      return WrappedRoute(child: const ProfilePage());
    },
  );
}

/// generated route for
/// [ProfileUpdatePage]
class ProfileUpdateRoute extends PageRouteInfo<ProfileUpdateRouteArgs> {
  ProfileUpdateRoute({
    Key? key,
    required AuthUser user,
    List<PageRouteInfo>? children,
  }) : super(
         ProfileUpdateRoute.name,
         args: ProfileUpdateRouteArgs(key: key, user: user),
         initialChildren: children,
       );

  static const String name = 'ProfileUpdateRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ProfileUpdateRouteArgs>();
      return WrappedRoute(
        child: ProfileUpdatePage(key: args.key, user: args.user),
      );
    },
  );
}

class ProfileUpdateRouteArgs {
  const ProfileUpdateRouteArgs({this.key, required this.user});

  final Key? key;

  final AuthUser user;

  @override
  String toString() {
    return 'ProfileUpdateRouteArgs{key: $key, user: $user}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ProfileUpdateRouteArgs) return false;
    return key == other.key && user == other.user;
  }

  @override
  int get hashCode => key.hashCode ^ user.hashCode;
}

/// generated route for
/// [ReferralPage]
class ReferralRoute extends PageRouteInfo<void> {
  const ReferralRoute({List<PageRouteInfo>? children})
    : super(ReferralRoute.name, initialChildren: children);

  static const String name = 'ReferralRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return WrappedRoute(child: const ReferralPage());
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
/// [SearchPage]
class SearchRoute extends PageRouteInfo<SearchRouteArgs> {
  SearchRoute({
    Key? key,
    String heroTag = 'search_field_home',
    String? initialQuery,
    List<PageRouteInfo>? children,
  }) : super(
         SearchRoute.name,
         args: SearchRouteArgs(
           key: key,
           heroTag: heroTag,
           initialQuery: initialQuery,
         ),
         initialChildren: children,
       );

  static const String name = 'SearchRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SearchRouteArgs>(
        orElse: () => const SearchRouteArgs(),
      );
      return WrappedRoute(
        child: SearchPage(
          key: args.key,
          heroTag: args.heroTag,
          initialQuery: args.initialQuery,
        ),
      );
    },
  );
}

class SearchRouteArgs {
  const SearchRouteArgs({
    this.key,
    this.heroTag = 'search_field_home',
    this.initialQuery,
  });

  final Key? key;

  final String heroTag;

  final String? initialQuery;

  @override
  String toString() {
    return 'SearchRouteArgs{key: $key, heroTag: $heroTag, initialQuery: $initialQuery}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SearchRouteArgs) return false;
    return key == other.key &&
        heroTag == other.heroTag &&
        initialQuery == other.initialQuery;
  }

  @override
  int get hashCode => key.hashCode ^ heroTag.hashCode ^ initialQuery.hashCode;
}

/// generated route for
/// [SessionsPage]
class SessionsRoute extends PageRouteInfo<void> {
  const SessionsRoute({List<PageRouteInfo>? children})
    : super(SessionsRoute.name, initialChildren: children);

  static const String name = 'SessionsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return WrappedRoute(child: const SessionsPage());
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

/// generated route for
/// [SubCategoriesPage]
class SubCategoriesRoute extends PageRouteInfo<SubCategoriesRouteArgs> {
  SubCategoriesRoute({
    required Category category,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         SubCategoriesRoute.name,
         args: SubCategoriesRouteArgs(category: category, key: key),
         initialChildren: children,
       );

  static const String name = 'SubCategoriesRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SubCategoriesRouteArgs>();
      return SubCategoriesPage(category: args.category, key: args.key);
    },
  );
}

class SubCategoriesRouteArgs {
  const SubCategoriesRouteArgs({required this.category, this.key});

  final Category category;

  final Key? key;

  @override
  String toString() {
    return 'SubCategoriesRouteArgs{category: $category, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SubCategoriesRouteArgs) return false;
    return category == other.category && key == other.key;
  }

  @override
  int get hashCode => category.hashCode ^ key.hashCode;
}

/// generated route for
/// [VerifyEmailPage]
class VerifyEmailRoute extends PageRouteInfo<VerifyEmailRouteArgs> {
  VerifyEmailRoute({
    Key? key,
    required String email,
    required String userUuid,
    List<PageRouteInfo>? children,
  }) : super(
         VerifyEmailRoute.name,
         args: VerifyEmailRouteArgs(key: key, email: email, userUuid: userUuid),
         initialChildren: children,
       );

  static const String name = 'VerifyEmailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<VerifyEmailRouteArgs>();
      return WrappedRoute(
        child: VerifyEmailPage(
          key: args.key,
          email: args.email,
          userUuid: args.userUuid,
        ),
      );
    },
  );
}

class VerifyEmailRouteArgs {
  const VerifyEmailRouteArgs({
    this.key,
    required this.email,
    required this.userUuid,
  });

  final Key? key;

  final String email;

  final String userUuid;

  @override
  String toString() {
    return 'VerifyEmailRouteArgs{key: $key, email: $email, userUuid: $userUuid}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! VerifyEmailRouteArgs) return false;
    return key == other.key &&
        email == other.email &&
        userUuid == other.userUuid;
  }

  @override
  int get hashCode => key.hashCode ^ email.hashCode ^ userUuid.hashCode;
}

/// generated route for
/// [WishlistPage]
class WishlistRoute extends PageRouteInfo<void> {
  const WishlistRoute({List<PageRouteInfo>? children})
    : super(WishlistRoute.name, initialChildren: children);

  static const String name = 'WishlistRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return WrappedRoute(child: const WishlistPage());
    },
  );
}

/// generated route for
/// [WriteReviewPage]
class WriteReviewRoute extends PageRouteInfo<WriteReviewRouteArgs> {
  WriteReviewRoute({
    Key? key,
    required String cpvUuid,
    required String productTitle,
    String? productImage,
    List<PageRouteInfo>? children,
  }) : super(
         WriteReviewRoute.name,
         args: WriteReviewRouteArgs(
           key: key,
           cpvUuid: cpvUuid,
           productTitle: productTitle,
           productImage: productImage,
         ),
         initialChildren: children,
       );

  static const String name = 'WriteReviewRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<WriteReviewRouteArgs>();
      return WrappedRoute(
        child: WriteReviewPage(
          key: args.key,
          cpvUuid: args.cpvUuid,
          productTitle: args.productTitle,
          productImage: args.productImage,
        ),
      );
    },
  );
}

class WriteReviewRouteArgs {
  const WriteReviewRouteArgs({
    this.key,
    required this.cpvUuid,
    required this.productTitle,
    this.productImage,
  });

  final Key? key;

  final String cpvUuid;

  final String productTitle;

  final String? productImage;

  @override
  String toString() {
    return 'WriteReviewRouteArgs{key: $key, cpvUuid: $cpvUuid, productTitle: $productTitle, productImage: $productImage}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! WriteReviewRouteArgs) return false;
    return key == other.key &&
        cpvUuid == other.cpvUuid &&
        productTitle == other.productTitle &&
        productImage == other.productImage;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      cpvUuid.hashCode ^
      productTitle.hashCode ^
      productImage.hashCode;
}
