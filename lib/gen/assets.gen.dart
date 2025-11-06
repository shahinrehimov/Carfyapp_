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

  /// List of all assets
  List<String> get values => [mainBasket, mainFavorite, mainHome, mainMessage, mainProfile];
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

  /// List of all assets
  List<AssetGenImage> get values => [
    basketNotLogged,
    favoriteNotLogged,
    messageNotLogged,
    profileNotLogged,
    splashLogoAndroid12,
    splashLogo,
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
