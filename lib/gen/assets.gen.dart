// dart format width=80

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

  /// File path: assets/icons/cart.svg
  String get cart => 'assets/icons/cart.svg';

  /// File path: assets/icons/category.svg
  String get category => 'assets/icons/category.svg';

  /// File path: assets/icons/delivery.svg
  String get delivery => 'assets/icons/delivery.svg';

  /// File path: assets/icons/favourite.svg
  String get favourite => 'assets/icons/favourite.svg';

  /// File path: assets/icons/home.svg
  String get home => 'assets/icons/home.svg';

  /// File path: assets/icons/logo.jpeg
  AssetGenImage get logo => const AssetGenImage('assets/icons/logo.jpeg');

  /// File path: assets/icons/notification.svg
  String get notification => 'assets/icons/notification.svg';

  /// File path: assets/icons/order.svg
  String get order => 'assets/icons/order.svg';

  /// File path: assets/icons/rental.svg
  String get rental => 'assets/icons/rental.svg';

  /// File path: assets/icons/user.svg
  String get user => 'assets/icons/user.svg';

  /// List of all assets
  List<dynamic> get values => [
    cart,
    category,
    delivery,
    favourite,
    home,
    logo,
    notification,
    order,
    rental,
    user,
  ];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();
}

class $AssetsOnboardingGen {
  const $AssetsOnboardingGen();

  /// File path: assets/onboarding/image_1.png
  AssetGenImage get image1 =>
      const AssetGenImage('assets/onboarding/image_1.png');

  /// File path: assets/onboarding/image_2.png
  AssetGenImage get image2 =>
      const AssetGenImage('assets/onboarding/image_2.png');

  /// File path: assets/onboarding/image_3.png
  AssetGenImage get image3 =>
      const AssetGenImage('assets/onboarding/image_3.png');

  /// List of all assets
  List<AssetGenImage> get values => [image1, image2, image3];
}

class Assets {
  const Assets._();

  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsOnboardingGen onboarding = $AssetsOnboardingGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

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
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}
