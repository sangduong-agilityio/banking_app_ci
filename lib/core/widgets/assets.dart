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
  static Widget Function({double? width, double? height, BoxFit? boxfit})
  lockDriver = _BALockDriveImage.new;

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

  static Widget Function({double? width, double? height, BoxFit? boxfit})
  contacts = _BAContactsImage.new;

  static Widget Function({double? width, double? height, BoxFit? boxfit})
  creditCard = _BACreditCardImage.new;

  static Widget Function({double? width, double? height, BoxFit? boxfit})
  creditCardIn = _BACreditCardInImage.new;

  static Widget Function({double? width, double? height, BoxFit? boxfit})
  fileParagraph = _BAFileParagraphImage.new;
  static Widget Function({double? width, double? height, BoxFit? boxfit})
  mobileBanking = _BAMobileBankingImage.new;

  static Widget Function({double? width, double? height, BoxFit? boxfit}) pig =
      _BAPigImage.new;

  static Widget Function({double? width, double? height, BoxFit? boxfit})
  receipt = _BAReceiptImage.new;

  static Widget Function({double? width, double? height, BoxFit? boxfit})
  syncDevices = _BASyncDevicesImage.new;

  static Widget Function({double? width, double? height, BoxFit? boxfit})
  wallet = _BAWalletImage.new;

  static Widget Function({double? width, double? height, BoxFit? boxfit})
  success = _BASuccessImage.new;

  static Widget Function({double? width, double? height, BoxFit? boxfit})
  empty = _BAEmptyImage.new;

  static Widget Function({double? width, double? height, BoxFit? boxfit})
  electric = _BAElectricImage.new;

  static Widget Function({double? width, double? height, BoxFit? boxfit})
  water = _BAWaterImage.new;

  static Widget Function({double? width, double? height, BoxFit? boxfit})
  internet = _BAInternetImage.new;

  static Widget Function({double? width, double? height, BoxFit? boxfit})
  transactionSuccess = _BATransactionSuccessImage.new;

  static Widget Function({double? width, double? height, BoxFit? boxfit})
  branch = _BABranchImage.new;

  static Widget Function({double? width, double? height, BoxFit? boxfit})
  interest = _BAInterestImage.new;

  static Widget Function({double? width, double? height, BoxFit? boxfit})
  exchange = _BAExchangeImage.new;

  static Widget Function({double? width, double? height, BoxFit? boxfit})
  exchangeRate = _BAExchangeRateImage.new;

  static Widget Function({double? width, double? height, BoxFit? boxfit})
  exchangeMoney = _BAExchangeMoneyImage.new;

  static Widget Function({double? width, double? height, BoxFit? boxfit}) swap =
      _BASwapImage.new;

  static Widget Function({double? width, double? height, BoxFit? boxfit})
  fingerprint = _BAFingerprintImage.new;

  static Widget Function({double? width, double? height, BoxFit? boxfit})
  beneficiary = _BABeneficiaryImage.new;

  static Widget Function({double? width, double? height, BoxFit? boxfit})
  saveOnline = _BASaveOnlineImage.new;
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

class _BASwapImage extends StatelessWidget {
  const _BASwapImage({this.width, this.height, this.boxfit});
  final double? height;
  final double? width;
  final BoxFit? boxfit;

  @override
  Widget build(BuildContext context) {
    return BAAssetImage(
      boxFit: boxfit,
      path: Assets.images.imgSwap.path,
      width: BAResponsive.scale(context, defaultValue: width ?? 40),
      height: BAResponsive.scale(context, defaultValue: height ?? 24),
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

class _BALockDriveImage extends StatelessWidget {
  const _BALockDriveImage({this.width, this.height, this.boxfit});
  final double? height;
  final double? width;
  final BoxFit? boxfit;

  @override
  Widget build(BuildContext context) {
    return BAAssetImage(
      boxFit: boxfit,
      path: Assets.images.imgLockDrive.path,
      width: BAResponsive.scale(context, defaultValue: width ?? 50),
      height: BAResponsive.scale(context, defaultValue: height ?? 73),
    );
  }
}

class _BAContactsImage extends StatelessWidget {
  const _BAContactsImage({this.width, this.height, this.boxfit});
  final double? height;
  final double? width;
  final BoxFit? boxfit;

  @override
  Widget build(BuildContext context) {
    return BAAssetImage(
      boxFit: boxfit,
      path: Assets.images.imgContacts.path,
      width: BAResponsive.scale(context, defaultValue: width ?? 28),
      height: BAResponsive.scale(context, defaultValue: height ?? 28),
    );
  }
}

class _BACreditCardImage extends StatelessWidget {
  const _BACreditCardImage({this.width, this.height, this.boxfit});
  final double? height;
  final double? width;
  final BoxFit? boxfit;

  @override
  Widget build(BuildContext context) {
    return BAAssetImage(
      boxFit: boxfit,
      path: Assets.images.imgCreditCard.path,
      width: BAResponsive.scale(context, defaultValue: width ?? 28),
      height: BAResponsive.scale(context, defaultValue: height ?? 28),
    );
  }
}

class _BACreditCardInImage extends StatelessWidget {
  const _BACreditCardInImage({this.width, this.height, this.boxfit});
  final double? height;
  final double? width;
  final BoxFit? boxfit;

  @override
  Widget build(BuildContext context) {
    return BAAssetImage(
      boxFit: boxfit,
      path: Assets.images.imgCreditCardIn.path,
      width: BAResponsive.scale(context, defaultValue: width ?? 28),
      height: BAResponsive.scale(context, defaultValue: height ?? 28),
    );
  }
}

class _BAFileParagraphImage extends StatelessWidget {
  const _BAFileParagraphImage({this.width, this.height, this.boxfit});
  final double? height;
  final double? width;
  final BoxFit? boxfit;

  @override
  Widget build(BuildContext context) {
    return BAAssetImage(
      boxFit: boxfit,
      path: Assets.images.imgFileParagraph.path,
      width: BAResponsive.scale(context, defaultValue: width ?? 28),
      height: BAResponsive.scale(context, defaultValue: height ?? 28),
    );
  }
}

class _BAMobileBankingImage extends StatelessWidget {
  const _BAMobileBankingImage({this.width, this.height, this.boxfit});
  final double? height;
  final double? width;
  final BoxFit? boxfit;

  @override
  Widget build(BuildContext context) {
    return BAAssetImage(
      boxFit: boxfit,
      path: Assets.images.imgMobileBanking.path,
      width: BAResponsive.scale(context, defaultValue: width ?? 28),
      height: BAResponsive.scale(context, defaultValue: height ?? 28),
    );
  }
}

class _BASaveOnlineImage extends StatelessWidget {
  const _BASaveOnlineImage({this.width, this.height, this.boxfit});
  final double? height;
  final double? width;
  final BoxFit? boxfit;

  @override
  Widget build(BuildContext context) {
    return BAAssetImage(
      boxFit: boxfit,
      path: Assets.images.imgPig.path,
      width: BAResponsive.scale(context, defaultValue: width ?? 28),
      height: BAResponsive.scale(context, defaultValue: height ?? 28),
    );
  }
}

class _BABeneficiaryImage extends StatelessWidget {
  const _BABeneficiaryImage({this.width, this.height, this.boxfit});
  final double? height;
  final double? width;
  final BoxFit? boxfit;

  @override
  Widget build(BuildContext context) {
    return BAAssetImage(
      boxFit: boxfit,
      path: Assets.images.imgContacts.path,
      width: BAResponsive.scale(context, defaultValue: width ?? 28),
      height: BAResponsive.scale(context, defaultValue: height ?? 28),
    );
  }
}

class _BAPigImage extends StatelessWidget {
  const _BAPigImage({this.width, this.height, this.boxfit});
  final double? height;
  final double? width;
  final BoxFit? boxfit;

  @override
  Widget build(BuildContext context) {
    return BAAssetImage(
      boxFit: boxfit,
      path: Assets.images.imgPig.path,
      width: BAResponsive.scale(context, defaultValue: width ?? 28),
      height: BAResponsive.scale(context, defaultValue: height ?? 28),
    );
  }
}

class _BAReceiptImage extends StatelessWidget {
  const _BAReceiptImage({this.width, this.height, this.boxfit});
  final double? height;
  final double? width;
  final BoxFit? boxfit;

  @override
  Widget build(BuildContext context) {
    return BAAssetImage(
      boxFit: boxfit,
      path: Assets.images.imgReceiptList.path,
      width: BAResponsive.scale(context, defaultValue: width ?? 28),
      height: BAResponsive.scale(context, defaultValue: height ?? 28),
    );
  }
}

class _BASyncDevicesImage extends StatelessWidget {
  const _BASyncDevicesImage({this.width, this.height, this.boxfit});
  final double? height;
  final double? width;
  final BoxFit? boxfit;

  @override
  Widget build(BuildContext context) {
    return BAAssetImage(
      boxFit: boxfit,
      path: Assets.images.imgSyncDevices.path,
      width: BAResponsive.scale(context, defaultValue: width ?? 28),
      height: BAResponsive.scale(context, defaultValue: height ?? 28),
    );
  }
}

class _BAWalletImage extends StatelessWidget {
  const _BAWalletImage({this.width, this.height, this.boxfit});
  final double? height;
  final double? width;
  final BoxFit? boxfit;

  @override
  Widget build(BuildContext context) {
    return BAAssetImage(
      boxFit: boxfit,
      path: Assets.images.imgWallet.path,
      width: BAResponsive.scale(context, defaultValue: width ?? 28),
      height: BAResponsive.scale(context, defaultValue: height ?? 28),
    );
  }
}

class _BASuccessImage extends StatelessWidget {
  const _BASuccessImage({this.width, this.height, this.boxfit});
  final double? height;
  final double? width;
  final BoxFit? boxfit;

  @override
  Widget build(BuildContext context) {
    return BAAssetImage(
      boxFit: boxfit,
      path: Assets.images.imgSuccess.path,
      width: BAResponsive.scale(context, defaultValue: width ?? 140),
      height: BAResponsive.scale(context, defaultValue: height ?? 140),
    );
  }
}

class _BAEmptyImage extends StatelessWidget {
  const _BAEmptyImage({this.width, this.height, this.boxfit});
  final double? height;
  final double? width;
  final BoxFit? boxfit;

  @override
  Widget build(BuildContext context) {
    return BAAssetImage(
      boxFit: boxfit,
      path: Assets.images.imgEmpty.path,
      width: BAResponsive.scale(context, defaultValue: width ?? 140),
      height: BAResponsive.scale(context, defaultValue: height ?? 140),
    );
  }
}

class _BAElectricImage extends StatelessWidget {
  const _BAElectricImage({this.width, this.height, this.boxfit});
  final double? height;
  final double? width;
  final BoxFit? boxfit;

  @override
  Widget build(BuildContext context) {
    return BAAssetImage(
      boxFit: boxfit,
      path: Assets.images.imgElectric.path,
      width: BAResponsive.scale(context, defaultValue: width ?? 90),
      height: BAResponsive.scale(context, defaultValue: height ?? 80),
    );
  }
}

class _BAWaterImage extends StatelessWidget {
  const _BAWaterImage({this.width, this.height, this.boxfit});
  final double? height;
  final double? width;
  final BoxFit? boxfit;

  @override
  Widget build(BuildContext context) {
    return BAAssetImage(
      boxFit: boxfit,
      path: Assets.images.imgWater.path,
      width: BAResponsive.scale(context, defaultValue: width ?? 90),
      height: BAResponsive.scale(context, defaultValue: height ?? 80),
    );
  }
}

class _BAInternetImage extends StatelessWidget {
  const _BAInternetImage({this.width, this.height, this.boxfit});
  final double? height;
  final double? width;
  final BoxFit? boxfit;

  @override
  Widget build(BuildContext context) {
    return BAAssetImage(
      boxFit: boxfit,
      path: Assets.images.imgInternet.path,
      width: BAResponsive.scale(context, defaultValue: width ?? 90),
      height: BAResponsive.scale(context, defaultValue: height ?? 80),
    );
  }
}

class _BAFingerprintImage extends StatelessWidget {
  const _BAFingerprintImage({this.width, this.height, this.boxfit});
  final double? height;
  final double? width;
  final BoxFit? boxfit;

  @override
  Widget build(BuildContext context) {
    return BAAssetImage(
      boxFit: boxfit,
      path: Assets.images.imgFingerprint.path,
      width: BAResponsive.scale(context, defaultValue: width ?? 64),
      height: BAResponsive.scale(context, defaultValue: height ?? 64),
    );
  }
}

class _BATransactionSuccessImage extends StatelessWidget {
  const _BATransactionSuccessImage({this.width, this.height, this.boxfit});
  final double? height;
  final double? width;
  final BoxFit? boxfit;

  @override
  Widget build(BuildContext context) {
    return BAAssetImage(
      boxFit: boxfit,
      path: Assets.images.imgDigitalBanking.path,
      width: BAResponsive.scale(context, defaultValue: width ?? 327),
      height: BAResponsive.scale(context, defaultValue: height ?? 204),
    );
  }
}

class _BABranchImage extends StatelessWidget {
  const _BABranchImage({this.width, this.height, this.boxfit});
  final double? height;
  final double? width;
  final BoxFit? boxfit;

  @override
  Widget build(BuildContext context) {
    return BAAssetImage(
      boxFit: boxfit,
      path: Assets.images.imgBranch.path,
      width: BAResponsive.scale(context, defaultValue: width ?? 100),
      height: BAResponsive.scale(context, defaultValue: height ?? 78),
    );
  }
}

class _BAInterestImage extends StatelessWidget {
  const _BAInterestImage({this.width, this.height, this.boxfit});
  final double? height;
  final double? width;
  final BoxFit? boxfit;

  @override
  Widget build(BuildContext context) {
    return BAAssetImage(
      boxFit: boxfit,
      path: Assets.images.imgInterest.path,
      width: BAResponsive.scale(context, defaultValue: width ?? 100),
      height: BAResponsive.scale(context, defaultValue: height ?? 78),
    );
  }
}

class _BAExchangeImage extends StatelessWidget {
  const _BAExchangeImage({this.width, this.height, this.boxfit});
  final double? height;
  final double? width;
  final BoxFit? boxfit;

  @override
  Widget build(BuildContext context) {
    return BAAssetImage(
      boxFit: boxfit,
      path: Assets.images.imgExchange.path,
      width: BAResponsive.scale(context, defaultValue: width ?? 100),
      height: BAResponsive.scale(context, defaultValue: height ?? 78),
    );
  }
}

class _BAExchangeRateImage extends StatelessWidget {
  const _BAExchangeRateImage({this.width, this.height, this.boxfit});
  final double? height;
  final double? width;
  final BoxFit? boxfit;

  @override
  Widget build(BuildContext context) {
    return BAAssetImage(
      boxFit: boxfit,
      path: Assets.images.imgExchangeRate.path,
      width: BAResponsive.scale(context, defaultValue: width ?? 100),
      height: BAResponsive.scale(context, defaultValue: height ?? 78),
    );
  }
}

class _BAExchangeMoneyImage extends StatelessWidget {
  const _BAExchangeMoneyImage({this.width, this.height, this.boxfit});
  final double? height;
  final double? width;
  final BoxFit? boxfit;

  @override
  Widget build(BuildContext context) {
    return BAAssetImage(
      boxFit: boxfit,
      path: Assets.images.imgExchangeMoney.path,
      width: BAResponsive.scale(context, defaultValue: width ?? 327),
      height: BAResponsive.scale(context, defaultValue: height ?? 213),
    );
  }
}
