// dart format width=120

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/address-pin-location.svg
  String get addressPinLocation => 'assets/icons/address-pin-location.svg';

  /// File path: assets/icons/apple-icon-logo.svg
  String get appleIconLogo => 'assets/icons/apple-icon-logo.svg';

  /// File path: assets/icons/arrow-narrow-left.svg
  String get arrowNarrowLeft => 'assets/icons/arrow-narrow-left.svg';

  /// File path: assets/icons/box.svg
  String get box => 'assets/icons/box.svg';

  /// File path: assets/icons/calendar.svg
  String get calendar => 'assets/icons/calendar.svg';

  /// File path: assets/icons/call.svg
  String get call => 'assets/icons/call.svg';

  /// File path: assets/icons/car-hatchback.svg
  String get carHatchback => 'assets/icons/car-hatchback.svg';

  /// File path: assets/icons/chevron-right.svg
  String get chevronRight => 'assets/icons/chevron-right.svg';

  /// File path: assets/icons/close-square.svg
  String get closeSquare => 'assets/icons/close-square.svg';

  /// File path: assets/icons/eye-off.svg
  String get eyeOff => 'assets/icons/eye-off.svg';

  /// File path: assets/icons/filters.svg
  String get filters => 'assets/icons/filters.svg';

  /// File path: assets/icons/gender.svg
  String get gender => 'assets/icons/gender.svg';

  /// File path: assets/icons/globe-2.svg
  String get globe2 => 'assets/icons/globe-2.svg';

  /// File path: assets/icons/google-icon-logo.svg
  String get googleIconLogo => 'assets/icons/google-icon-logo.svg';

  /// File path: assets/icons/heart-filled.svg
  String get heartFilled => 'assets/icons/heart-filled.svg';

  /// File path: assets/icons/heart.svg
  String get heart => 'assets/icons/heart.svg';

  /// File path: assets/icons/location-icon.svg
  String get locationIcon => 'assets/icons/location-icon.svg';

  /// File path: assets/icons/logo-white.svg
  String get logoWhite => 'assets/icons/logo-white.svg';

  /// File path: assets/icons/logo.svg
  String get logo => 'assets/icons/logo.svg';

  /// File path: assets/icons/main-basket.svg
  String get mainBasket => 'assets/icons/main-basket.svg';

  /// File path: assets/icons/main-favorite.svg
  String get mainFavorite => 'assets/icons/main-favorite.svg';

  /// File path: assets/icons/main-home.svg
  String get mainHome => 'assets/icons/main-home.svg';

  /// File path: assets/icons/main-message.svg
  String get mainMessage => 'assets/icons/main-message.svg';

  /// File path: assets/icons/main-profile.svg
  String get mainProfile => 'assets/icons/main-profile.svg';

  /// File path: assets/icons/message.svg
  String get message => 'assets/icons/message.svg';

  /// File path: assets/icons/minus.svg
  String get minus => 'assets/icons/minus.svg';

  /// File path: assets/icons/mobile.svg
  String get mobile => 'assets/icons/mobile.svg';

  /// File path: assets/icons/notification.svg
  String get notification => 'assets/icons/notification.svg';

  /// File path: assets/icons/password.svg
  String get password => 'assets/icons/password.svg';

  /// File path: assets/icons/plus.svg
  String get plus => 'assets/icons/plus.svg';

  /// File path: assets/icons/profile.svg
  String get profile => 'assets/icons/profile.svg';

  /// File path: assets/icons/sale-square.svg
  String get saleSquare => 'assets/icons/sale-square.svg';

  /// File path: assets/icons/search.svg
  String get search => 'assets/icons/search.svg';

  /// File path: assets/icons/support.svg
  String get support => 'assets/icons/support.svg';

  /// List of all assets
  List<String> get values => [
    addressPinLocation,
    appleIconLogo,
    arrowNarrowLeft,
    box,
    calendar,
    call,
    carHatchback,
    chevronRight,
    closeSquare,
    eyeOff,
    filters,
    gender,
    globe2,
    googleIconLogo,
    heartFilled,
    heart,
    locationIcon,
    logoWhite,
    logo,
    mainBasket,
    mainFavorite,
    mainHome,
    mainMessage,
    mainProfile,
    message,
    minus,
    mobile,
    notification,
    password,
    plus,
    profile,
    saleSquare,
    search,
    support,
  ];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/basket-not-logged.png
  AssetGenImage get basketNotLogged => const AssetGenImage('assets/images/basket-not-logged.png');

  /// File path: assets/images/favorite-not-logged.png
  AssetGenImage get favoriteNotLogged => const AssetGenImage('assets/images/favorite-not-logged.png');

  /// File path: assets/images/message-not-logged.png
  AssetGenImage get messageNotLogged => const AssetGenImage('assets/images/message-not-logged.png');

  /// File path: assets/images/profile-not-logged.png
  AssetGenImage get profileNotLogged => const AssetGenImage('assets/images/profile-not-logged.png');

  /// File path: assets/images/splash-logo-android12.png
  AssetGenImage get splashLogoAndroid12 => const AssetGenImage('assets/images/splash-logo-android12.png');

  /// File path: assets/images/splash-logo.png
  AssetGenImage get splashLogo => const AssetGenImage('assets/images/splash-logo.png');

  /// File path: assets/images/successfully-registered.png
  AssetGenImage get successfullyRegistered => const AssetGenImage('assets/images/successfully-registered.png');

  /// List of all assets
  List<AssetGenImage> get values => [
    basketNotLogged,
    favoriteNotLogged,
    messageNotLogged,
    profileNotLogged,
    splashLogoAndroid12,
    splashLogo,
    successfullyRegistered,
  ];
}

class Assets {
  const Assets._();

  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName, {this.size, this.flavors = const {}, this.animation});

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({required this.isAnimation, required this.duration, required this.frames});

  final bool isAnimation;
  final Duration duration;
  final int frames;
}
