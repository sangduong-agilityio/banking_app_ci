import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:laza_design/core/gen_assets/assets.gen.dart';
import 'package:laza_design/ui/foundations/colors.dart';

class OlSvgAssetImage extends StatelessWidget {
  OlSvgAssetImage({
    required this.path,
    super.key,
    this.package = 'laza_design',
    this.errorBuilder,
    this.width,
    this.height,
    this.boxFit,
    this.color,
  }) : assert(
          !path.startsWith('http'),
          'Asset Image path should not start with http or https',
        );

  final String path;
  final String? package;
  final Widget? errorBuilder;
  final double? width;
  final double? height;
  final BoxFit? boxFit;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      path,
      package: package,
      width: width,
      height: height,
      fit: boxFit ?? BoxFit.fill,
      colorFilter:
          (color != null) ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
    );
  }
}

class OlSvgBuildInAssetImage extends StatelessWidget {
  final String path;
  final double width;
  final double height;
  final Color? color;
  const OlSvgBuildInAssetImage({
    super.key,
    required this.path,
    this.height = 24,
    this.width = 24,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return OlSvgAssetImage(
      path: path,
      width: width,
      height: height,
      color: color,
    );
  }
}

class LSIcons {
  static Widget icArrowLeft = OlSvgBuildInAssetImage(
    path: Assets.icons.icArrowLeft.path,
    width: 25,
    height: 25,
  );
  static Widget icSearch = OlSvgBuildInAssetImage(
    path: Assets.icons.icSearch.path,
    width: 25,
    height: 25,
    color: LSColors.grey500,
  );
  static Widget icFacebook = OlSvgBuildInAssetImage(
    path: Assets.icons.icFacebook.path,
    width: 22,
    height: 22,
  );
  static Widget icTwitter = OlSvgBuildInAssetImage(
    path: Assets.icons.icTwitter.path,
    width: 22,
    height: 22,
  );
  static Widget icMenu = OlSvgBuildInAssetImage(
    path: Assets.icons.icMenu.path,
    width: 25,
    height: 25,
  );
  static Widget icBag = OlSvgBuildInAssetImage(
    path: Assets.icons.icBag.path,
    width: 25,
    height: 25,
  );
  static Widget icVoice = OlSvgBuildInAssetImage(
    path: Assets.icons.icVoice.path,
    width: 24,
    height: 24,
  );
  static Widget icHome = OlSvgBuildInAssetImage(
    path: Assets.icons.icHome.path,
    width: 19,
    height: 20,
  );
  static Widget icHeart = OlSvgBuildInAssetImage(
    path: Assets.icons.icHeart.path,
    width: 19,
    height: 20,
  );
  static Widget icWallet = OlSvgBuildInAssetImage(
    path: Assets.icons.icWallet.path,
    width: 19,
    height: 20,
  );
}
