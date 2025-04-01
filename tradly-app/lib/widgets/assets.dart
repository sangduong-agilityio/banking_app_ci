import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tradly_app/extensions/context_extensions.dart';
import 'package:tradly_app/resources/assets_generated/assets.gen.dart';
import 'package:tradly_app/utils/responsive.dart';

class TAAssetImage extends StatelessWidget {
  TAAssetImage({
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
    return _TAImageLoader(
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

class TACachedNetworkImage extends StatelessWidget {
  const TACachedNetworkImage({
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
    return _TAImageLoader(
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

class _TAImageLoader extends StatelessWidget {
  const _TAImageLoader({
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

            return errorBuilder ??
                Icon(
                  Icons.broken_image,
                  size: width,
                );
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
            return errorBuilder ??
                Icon(
                  Icons.broken_image,
                  size: width,
                );
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

            return errorBuilder ??
                Icon(
                  Icons.broken_image,
                  size: width,
                );
          },
          imageBuilder:
              (BuildContext context, ImageProvider<Object> provider) =>
                  Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: provider,
              ),
            ),
          ),
        );
    }
  }
}

class TAAssets {
  static Widget Function({
    double? width,
    double? height,
    BoxFit? boxfit,
  }) onboardingBusiness = _TAOnboardingBusinessImage.new;

  static Widget Function({
    double? width,
    double? height,
    BoxFit? boxfit,
  }) onboardingSocial = _TAOnboardingSocialImage.new;

  static Widget Function({
    double? width,
    double? height,
    BoxFit? boxfit,
  }) onboardingSupport = _TAOnboardingSupportImage.new;
}

class _TAOnboardingBusinessImage extends StatelessWidget {
  const _TAOnboardingBusinessImage({
    this.width,
    this.height,
    this.boxfit,
  });
  final double? height;
  final double? width;
  final BoxFit? boxfit;

  @override
  Widget build(BuildContext context) {
    return TAAssetImage(
      boxFit: boxfit,
      path: Assets.images.imgOnboardingBusiness.path,
      width: TaResponsive.scale(
        context,
        defaultValue: width ?? 285,
      ),
      height: TaResponsive.scale(
        context,
        defaultValue: height ?? 243,
      ),
    );
  }
}

class _TAOnboardingSocialImage extends StatelessWidget {
  const _TAOnboardingSocialImage({
    this.width,
    this.height,
    this.boxfit,
  });
  final double? height;
  final double? width;
  final BoxFit? boxfit;

  @override
  Widget build(BuildContext context) {
    return TAAssetImage(
      boxFit: boxfit,
      path: Assets.images.imgOnboardingSocial.path,
      width: TaResponsive.scale(
        context,
        defaultValue: width ?? 302,
      ),
      height: TaResponsive.scale(
        context,
        defaultValue: height ?? 248,
      ),
    );
  }
}

class _TAOnboardingSupportImage extends StatelessWidget {
  const _TAOnboardingSupportImage({
    this.width,
    this.height,
    this.boxfit,
  });
  final double? height;
  final double? width;
  final BoxFit? boxfit;

  @override
  Widget build(BuildContext context) {
    return TAAssetImage(
      boxFit: boxfit,
      path: Assets.images.imgOnboardingSupport.path,
      width: TaResponsive.scale(
        context,
        defaultValue: width ?? 285,
      ),
      height: TaResponsive.scale(
        context,
        defaultValue: height ?? 243,
      ),
    );
  }
}
