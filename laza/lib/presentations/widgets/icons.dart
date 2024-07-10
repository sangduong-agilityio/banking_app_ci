import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:laza/core/gen_assets/assets.gen.dart';
import 'package:laza/core/color/colors.dart';

class LSSvgAssetImage extends StatelessWidget {
  LSSvgAssetImage({
    required this.path,
    super.key,
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
  final Widget? errorBuilder;
  final double? width;
  final double? height;
  final BoxFit? boxFit;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      path,
      width: width,
      height: height,
      fit: boxFit ?? BoxFit.fill,
      colorFilter:
          (color != null) ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
    );
  }
}

class LSSvgBuildInAssetImage extends StatelessWidget {
  final String path;
  final double width;
  final double height;
  final Color? color;
  const LSSvgBuildInAssetImage({
    super.key,
    required this.path,
    this.height = 24,
    this.width = 24,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return LSSvgAssetImage(
      path: path,
      width: width,
      height: height,
      color: color,
    );
  }
}

class LSIcons {
  static Widget icArrowLeft = LSSvgBuildInAssetImage(
    path: Assets.icons.icArrowLeft.path,
    width: 25,
    height: 25,
  );
  static Widget icSearch = LSSvgBuildInAssetImage(
    path: Assets.icons.icSearch.path,
    width: 20,
    height: 20,
    color: LSColors.grey500,
  );
  static Widget icFacebook = LSSvgBuildInAssetImage(
    path: Assets.icons.icFacebook.path,
    width: 22,
    height: 22,
  );
  static Widget icGoogle = LSSvgBuildInAssetImage(
    path: Assets.icons.icGoogle.path,
    width: 22,
    height: 22,
  );
  static Widget icTwitter = LSSvgBuildInAssetImage(
    path: Assets.icons.icTwitter.path,
    width: 22,
    height: 22,
  );
  static Widget icMenu = LSSvgBuildInAssetImage(
    path: Assets.icons.icMenu.path,
    width: 25,
    height: 25,
  );
  static Widget icBag = LSSvgBuildInAssetImage(
    path: Assets.icons.icBag.path,
    width: 25,
    height: 25,
  );
  static Widget icVoice = LSSvgBuildInAssetImage(
    path: Assets.icons.icVoice.path,
    width: 24,
    height: 24,
  );
  static Widget icHome = LSSvgBuildInAssetImage(
    path: Assets.icons.icHome.path,
    width: 19,
    height: 20,
  );
  static Widget icHeartBreak = LSSvgBuildInAssetImage(
    path: Assets.icons.icHeartBreak.path,
    width: 19,
    height: 20,
  );
  static Widget icWallet = LSSvgBuildInAssetImage(
    path: Assets.icons.icWallet.path,
    width: 19,
    height: 20,
    color: LSColors.black,
  );
  static Widget icInvertedMenu = LSSvgBuildInAssetImage(
    path: Assets.icons.icInvertedMenu.path,
    width: 25,
    height: 25,
  );
  static Widget icSun = LSSvgBuildInAssetImage(
    path: Assets.icons.icSun.path,
    width: 25,
    height: 25,
  );
  static Widget icInformation = LSSvgBuildInAssetImage(
    path: Assets.icons.icInformation.path,
    width: 25,
    height: 25,
  );
  static Widget icLogout = LSSvgBuildInAssetImage(
    path: Assets.icons.icLogout.path,
    width: 25,
    height: 25,
  );
  static Widget icSort = LSSvgBuildInAssetImage(
    path: Assets.icons.icSort.path,
    width: 15,
    height: 15,
  );
  static Widget icHeart = LSSvgBuildInAssetImage(
    path: Assets.icons.icHeart.path,
    width: 25,
    height: 25,
  );
}
