import 'dart:developer';

import 'package:banking_app/core/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/assets_generated/assets.gen.dart';
import 'package:banking_app/core/utils/responsive.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BAAssetImage extends StatelessWidget {
  BAAssetImage({
    required this.path,
    super.key,
    this.errorBuilder,
    this.width,
    this.height,
    this.color,
    this.boxFit,
    this.type = ImageLoaderType.assetPNG,
  }) : assert(
         !path.startsWith('http'),
         'Asset Image path should not start with http or https',
       );

  final String path;
  final Widget? errorBuilder;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit? boxFit;
  final ImageLoaderType type;

  @override
  Widget build(BuildContext context) {
    return _BAImageLoader(
      url: path,
      type: type,
      errorBuilder: errorBuilder,
      width: width,
      height: height,
      color: color,
      boxFit: boxFit,
    );
  }
}

class BACachedNetworkImage extends StatelessWidget {
  const BACachedNetworkImage({
    required this.url,
    this.width = 40,
    this.height = 40,
    this.boxFit = BoxFit.contain,
    this.errorBuilder,
    super.key,
  });

  final String url;
  final Widget? errorBuilder;
  final double? width;
  final double? height;
  final BoxFit? boxFit;

  @override
  Widget build(BuildContext context) {
    return _BAImageLoader(
      url: url,
      type: ImageLoaderType.cachedNetwork,
      errorBuilder: errorBuilder,
      width: width,
      height: height,
      boxFit: boxFit,
    );
  }
}

enum ImageLoaderType { assetPNG, assetSVG, cachedNetwork }

class _BAImageLoader extends StatelessWidget {
  const _BAImageLoader({
    required this.type,
    required this.url,
    this.errorBuilder,
    this.width,
    this.height,
    this.color,
    this.boxFit = BoxFit.cover,
  });

  final ImageLoaderType type;

  final String url;

  final Widget? errorBuilder;

  final double? width;
  final double? height;
  final Color? color;
  final BoxFit? boxFit;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case ImageLoaderType.assetPNG:
        return Image.asset(
          url,
          fit: boxFit,
          errorBuilder:
              (BuildContext context, Object error, StackTrace? stackTrace) {
                log('Image $url load failed. Error: $error');

                return errorBuilder ?? Icon(Icons.broken_image, size: width);
              },
          width: width,
          height: height,
          color: color,
        );
      case ImageLoaderType.assetSVG:
        return SvgPicture.asset(
          url,
          colorFilter: ColorFilter.mode(
            color ?? context.colorScheme.onSurface,
            BlendMode.srcIn,
          ),
          fit: boxFit ?? BoxFit.contain,
          placeholderBuilder: (BuildContext context) {
            return errorBuilder ?? Icon(Icons.broken_image, size: width);
          },
          width: width,
          height: height,
        );

      case ImageLoaderType.cachedNetwork:
        return CachedNetworkImage(
          imageUrl: url,
          fit: boxFit,
          width: width,
          height: height,
          errorWidget: (BuildContext context, String url, dynamic error) {
            log('Image $url load failed. Error: $error');

            return errorBuilder ?? Icon(Icons.broken_image, size: width);
          },
          imageBuilder:
              (BuildContext context, ImageProvider<Object> provider) =>
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(image: provider),
                    ),
                  ),
        );
    }
  }
}

class BAAssets {
  static Widget Function({
    double? width,
    double? height,
    BoxFit? boxfit,
    Color? color,
  })
  home = _BAHomeImage.new;

  static Widget Function({
    double? width,
    double? height,
    BoxFit? boxfit,
    Color? color,
  })
  homeFilled = _BAHomeFilledImage.new;

  static Widget Function({
    double? width,
    double? height,
    BoxFit? boxfit,
    Color? color,
  })
  search = _BASearchImage.new;

  static Widget Function({
    double? width,
    double? height,
    BoxFit? boxfit,
    Color? color,
  })
  message = _BAMessageImage.new;
  static Widget Function({
    double? width,
    double? height,
    BoxFit? boxfit,
    Color? color,
  })
  messageFilled = _BAMessageFilledImage.new;

  static Widget Function({
    double? width,
    double? height,
    BoxFit? boxfit,
    Color? color,
  })
  setting = _BASettingImage.new;

  static Widget Function({
    double? width,
    double? height,
    BoxFit? boxfit,
    Color? color,
  })
  settingFilled = _BASettingFilledImage.new;
}

class _BAHomeImage extends StatelessWidget {
  const _BAHomeImage({this.width, this.height, this.boxfit, this.color});
  final double? height;
  final double? width;
  final BoxFit? boxfit;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return BAAssetImage(
      boxFit: boxfit,
      type: ImageLoaderType.assetSVG,
      path: Assets.icons.icHome.path,
      width: BAResponsive.scale(context, defaultValue: width ?? 20),
      height: BAResponsive.scale(context, defaultValue: height ?? 20),
      color: color ?? context.colorScheme.inverseSurface,
    );
  }
}

class _BAHomeFilledImage extends StatelessWidget {
  const _BAHomeFilledImage({this.width, this.height, this.boxfit, this.color});
  final double? height;
  final double? width;
  final BoxFit? boxfit;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return BAAssetImage(
      boxFit: boxfit,
      type: ImageLoaderType.assetSVG,
      path: Assets.icons.icHomeFilled.path,
      width: BAResponsive.scale(context, defaultValue: width ?? 20),
      height: BAResponsive.scale(context, defaultValue: height ?? 20),
      color: color ?? context.colorScheme.inverseSurface,
    );
  }
}

class _BASearchImage extends StatelessWidget {
  const _BASearchImage({this.width, this.height, this.boxfit, this.color});
  final double? height;
  final double? width;
  final BoxFit? boxfit;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return BAAssetImage(
      boxFit: boxfit,
      type: ImageLoaderType.assetSVG,
      path: Assets.icons.icSearchLoading.path,
      width: BAResponsive.scale(context, defaultValue: width ?? 20),
      height: BAResponsive.scale(context, defaultValue: height ?? 20),
      color: color ?? context.colorScheme.inverseSurface,
    );
  }
}

class _BAMessageImage extends StatelessWidget {
  const _BAMessageImage({this.width, this.height, this.boxfit, this.color});
  final double? height;
  final double? width;
  final BoxFit? boxfit;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return BAAssetImage(
      boxFit: boxfit,
      type: ImageLoaderType.assetSVG,
      path: Assets.icons.icEmail.path,
      width: BAResponsive.scale(context, defaultValue: width ?? 20),
      height: BAResponsive.scale(context, defaultValue: height ?? 20),
      color: color ?? context.colorScheme.inverseSurface,
    );
  }
}

class _BAMessageFilledImage extends StatelessWidget {
  const _BAMessageFilledImage({
    this.width,
    this.height,
    this.boxfit,
    this.color,
  });
  final double? height;
  final double? width;
  final BoxFit? boxfit;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return BAAssetImage(
      boxFit: boxfit,
      type: ImageLoaderType.assetSVG,
      path: Assets.icons.icEmailFilled.path,
      width: BAResponsive.scale(context, defaultValue: width ?? 20),
      height: BAResponsive.scale(context, defaultValue: height ?? 20),
      color: color ?? context.colorScheme.inverseSurface,
    );
  }
}

class _BASettingImage extends StatelessWidget {
  const _BASettingImage({this.width, this.height, this.boxfit, this.color});
  final double? height;
  final double? width;
  final BoxFit? boxfit;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return BAAssetImage(
      boxFit: boxfit,
      type: ImageLoaderType.assetSVG,
      path: Assets.icons.icSettings.path,
      width: BAResponsive.scale(context, defaultValue: width ?? 20),
      height: BAResponsive.scale(context, defaultValue: height ?? 20),
      color: color ?? context.colorScheme.inverseSurface,
    );
  }
}

class _BASettingFilledImage extends StatelessWidget {
  const _BASettingFilledImage({
    this.width,
    this.height,
    this.boxfit,
    this.color,
  });
  final double? height;
  final double? width;
  final BoxFit? boxfit;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return BAAssetImage(
      boxFit: boxfit,
      type: ImageLoaderType.assetSVG,
      path: Assets.icons.icSettingsFilled.path,
      width: BAResponsive.scale(context, defaultValue: width ?? 20),
      height: BAResponsive.scale(context, defaultValue: height ?? 20),
      color: color ?? context.colorScheme.inverseSurface,
    );
  }
}
