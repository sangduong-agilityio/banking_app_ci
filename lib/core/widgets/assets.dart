import 'dart:developer';
import 'dart:io';

import 'package:banking_app/core/common/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/assets_generated/assets.gen.dart';
import 'package:banking_app/core/common/utils/responsive.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A widget to display images from assets.
///
/// This widget can handle different types of images, including PNG and SVG.
/// It also provides error handling and allows for customization of width, height, color, and box fit.
class BAAssetImage extends StatelessWidget {
  /// Creates a [BAAssetImage] widget.
  ///
  /// The [path] parameter is required and must not start with 'http' or 'https'.
  const BAAssetImage({
    required this.path,
    super.key,
    this.errorBuilder,
    this.width,
    this.height,
    this.color,
    this.boxFit,
    this.type = ImageLoaderType.assetPNG,
  });

  /// The path to the asset image.
  final String path;

  /// A builder function to create a widget to display when an error occurs.
  final Widget? errorBuilder;

  /// The width of the image.
  final double? width;

  /// The height of the image.
  final double? height;

  /// The color to apply to the image.
  final Color? color;

  /// How the image should be inscribed into the box.
  final BoxFit? boxFit;

  /// The type of image loader to use.
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

/// A widget to display and cache network images.
///
/// This widget uses the `cached_network_image` package to efficiently load and cache images from the network.
class BACachedNetworkImage extends StatelessWidget {
  /// Creates a [BACachedNetworkImage] widget.
  const BACachedNetworkImage({
    required this.url,
    this.width = 40,
    this.height = 40,
    this.boxFit = BoxFit.contain,
    this.errorBuilder,
    super.key,
  });

  /// The URL of the image to display.
  final String url;

  /// A builder function to create a widget to display when an error occurs.
  final Widget? errorBuilder;

  /// The width of the image.
  final double? width;

  /// The height of the image.
  final double? height;

  /// How the image should be inscribed into the box.
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

/// An enumeration of the different types of image loaders.
enum ImageLoaderType {
  /// Load an image from the assets as a PNG.
  assetPNG,

  /// Load an image from the assets as an SVG.
  assetSVG,

  /// Load an image from the network and cache it.
  cachedNetwork,
}

/// A private helper class that handles the actual image loading logic.
///
/// This class is used by [BAAssetImage] and [BACachedNetworkImage] to display images.
class _BAImageLoader extends StatelessWidget {
  /// Creates a [_BAImageLoader] widget.
  const _BAImageLoader({
    required this.type,
    required this.url,
    this.errorBuilder,
    this.width,
    this.height,
    this.color,
    this.boxFit = BoxFit.cover,
  });

  /// The type of image loader to use.
  final ImageLoaderType type;

  /// The URL or path of the image to display.
  final String url;

  /// A builder function to create a widget to display when an error occurs.
  final Widget? errorBuilder;

  /// The width of the image.
  final double? width;

  /// The height of the image.
  final double? height;

  /// The color to apply to the image.
  final Color? color;

  /// How the image should be inscribed into the box.
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

/// A class that provides easy access to all the assets in the app.
///
/// This class contains static methods that return widgets for each asset.
class BAAssets {
  /// A widget for the lock driver image.
  static Widget Function({double? width, double? height, BoxFit? boxfit})
  lockDriver = _BALockDriveImage.new;

  /// A widget for the home icon.
  static Widget Function({
    double? width,
    double? height,
    BoxFit? boxfit,
    Color? color,
  })
  home = _BAHomeImage.new;

  /// A widget for the filled home icon.
  static Widget Function({
    double? width,
    double? height,
    BoxFit? boxfit,
    Color? color,
  })
  homeFilled = _BAHomeFilledImage.new;

  /// A widget for the search icon.
  static Widget Function({
    double? width,
    double? height,
    BoxFit? boxfit,
    Color? color,
  })
  search = _BASearchImage.new;

  /// A widget for the message icon.
  static Widget Function({
    double? width,
    double? height,
    BoxFit? boxfit,
    Color? color,
  })
  message = _BAMessageImage.new;

  /// A widget for the filled message icon.
  static Widget Function({
    double? width,
    double? height,
    BoxFit? boxfit,
    Color? color,
  })
  messageFilled = _BAMessageFilledImage.new;

  /// A widget for the settings icon.
  static Widget Function({
    double? width,
    double? height,
    BoxFit? boxfit,
    Color? color,
  })
  setting = _BASettingImage.new;

  /// A widget for the filled settings icon.
  static Widget Function({
    double? width,
    double? height,
    BoxFit? boxfit,
    Color? color,
  })
  settingFilled = _BASettingFilledImage.new;

  /// A widget for the contacts image.
  static Widget Function({double? width, double? height, BoxFit? boxfit})
  contacts = _BAContactsImage.new;

  /// A widget for the credit card image.
  static Widget Function({double? width, double? height, BoxFit? boxfit})
  creditCard = _BACreditCardImage.new;

  /// A widget for the credit card in image.
  static Widget Function({double? width, double? height, BoxFit? boxfit})
  creditCardIn = _BACreditCardInImage.new;

  /// A widget for the file paragraph image.
  static Widget Function({double? width, double? height, BoxFit? boxfit})
  fileParagraph = _BAFileParagraphImage.new;

  /// A widget for the mobile banking image.
  static Widget Function({double? width, double? height, BoxFit? boxfit})
  mobileBanking = _BAMobileBankingImage.new;

  /// A widget for the pig image.
  static Widget Function({double? width, double? height, BoxFit? boxfit}) pig =
      _BAPigImage.new;

  /// A widget for the receipt image.
  static Widget Function({double? width, double? height, BoxFit? boxfit})
  receipt = _BAReceiptImage.new;

  /// A widget for the sync devices image.
  static Widget Function({double? width, double? height, BoxFit? boxfit})
  syncDevices = _BASyncDevicesImage.new;

  /// A widget for the wallet image.
  static Widget Function({double? width, double? height, BoxFit? boxfit})
  wallet = _BAWalletImage.new;

  /// A widget for the empty image.
  static Widget Function({double? width, double? height, BoxFit? boxfit})
  empty = _BAEmptyImage.new;

  /// A widget for the electric image.
  static Widget Function({double? width, double? height, BoxFit? boxfit})
  electric = _BAElectricImage.new;

  /// A widget for the water image.
  static Widget Function({double? width, double? height, BoxFit? boxfit})
  water = _BAWaterImage.new;

  /// A widget for the water bill image.
  static Widget Function({double? width, double? height, BoxFit? boxfit})
  waterBill = _BAWaterBillImage.new;

  /// A widget for the internet image.
  static Widget Function({double? width, double? height, BoxFit? boxfit})
  internet = _BAInternetImage.new;

  /// A widget for the internet bill image.
  static Widget Function({double? width, double? height, BoxFit? boxfit})
  internetBill = _BAInternetBillImage.new;

  /// A widget for the transfer money bill image.
  static Widget Function({double? width, double? height, BoxFit? boxfit})
  transferMoneyBill = _BATransferMoneyBillImage.new;

  /// A widget for the electric bill image.
  static Widget Function({double? width, double? height, BoxFit? boxfit})
  electricBill = _BAElectricBillImage.new;

  /// A widget for the transaction success image.
  static Widget Function({double? width, double? height, BoxFit? boxfit})
  transactionSuccess = _BATransactionSuccessImage.new;

  /// A widget for the branch image.
  static Widget Function({double? width, double? height, BoxFit? boxfit})
  branch = _BABranchImage.new;

  /// A widget for the interest image.
  static Widget Function({double? width, double? height, BoxFit? boxfit})
  interest = _BAInterestImage.new;

  /// A widget for the exchange image.
  static Widget Function({double? width, double? height, BoxFit? boxfit})
  exchange = _BAExchangeImage.new;

  /// A widget for the exchange rate image.
  static Widget Function({double? width, double? height, BoxFit? boxfit})
  exchangeRate = _BAExchangeRateImage.new;

  /// A widget for the exchange money image.
  static Widget Function({double? width, double? height, BoxFit? boxfit})
  exchangeMoney = _BAExchangeMoneyImage.new;

  /// A widget for the swap image.
  static Widget Function({double? width, double? height, BoxFit? boxfit}) swap =
      _BASwapImage.new;

  /// A widget for the fingerprint image.
  static Widget Function({double? width, double? height, BoxFit? boxfit})
  fingerprint = _BAFingerprintImage.new;

  /// A widget for the beneficiary image.
  static Widget Function({double? width, double? height, BoxFit? boxfit})
  beneficiary = _BABeneficiaryImage.new;

  /// A widget for the save online image.
  static Widget Function({double? width, double? height, BoxFit? boxfit})
  saveOnline = _BASaveOnlineImage.new;

  /// A widget for the transfer success image.
  static Widget Function({double? width, double? height, BoxFit? boxfit})
  transferSuccess = _BATransferSuccessImage.new;
}

/// A widget for displaying the home icon.
class _BAHomeImage extends StatelessWidget {
  /// Creates a [_BAHomeImage] widget.
  const _BAHomeImage({this.width, this.height, this.boxfit, this.color});

  /// The height of the image.
  final double? height;

  /// The width of the image.
  final double? width;

  /// How the image should be inscribed into the box.
  final BoxFit? boxfit;

  /// The color to apply to the image.
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

/// A widget for displaying the filled home icon.
class _BAHomeFilledImage extends StatelessWidget {
  /// Creates a [_BAHomeFilledImage] widget.
  const _BAHomeFilledImage({this.width, this.height, this.boxfit, this.color});

  /// The height of the image.
  final double? height;

  /// The width of the image.
  final double? width;

  /// How the image should be inscribed into the box.
  final BoxFit? boxfit;

  /// The color to apply to the image.
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

/// A widget for displaying the search icon.
class _BASearchImage extends StatelessWidget {
  /// Creates a [_BASearchImage] widget.
  const _BASearchImage({this.width, this.height, this.boxfit, this.color});

  /// The height of the image.
  final double? height;

  /// The width of the image.
  final double? width;

  /// How the image should be inscribed into the box.
  final BoxFit? boxfit;

  /// The color to apply to the image.
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

/// A widget for displaying the water bill icon.
class _BAWaterBillImage extends StatelessWidget {
  /// Creates a [_BAWaterBillImage] widget.
  const _BAWaterBillImage({this.width, this.height, this.boxfit, this.color});

  /// The height of the image.
  final double? height;

  /// The width of the image.
  final double? width;

  /// How the image should be inscribed into the box.
  final BoxFit? boxfit;

  /// The color to apply to the image.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return BAAssetImage(
      boxFit: boxfit,
      type: ImageLoaderType.assetSVG,
      path: Assets.icons.icWater.path,
      width: BAResponsive.scale(context, defaultValue: width ?? 20),
      height: BAResponsive.scale(context, defaultValue: height ?? 20),
      color: color ?? context.colorScheme.onPrimary,
    );
  }
}

/// A widget for displaying the transfer money bill icon.
class _BATransferMoneyBillImage extends StatelessWidget {
  /// Creates a [_BATransferMoneyBillImage] widget.
  const _BATransferMoneyBillImage({
    this.width,
    this.height,
    this.boxfit,
    this.color,
  });

  /// The height of the image.
  final double? height;

  /// The width of the image.
  final double? width;

  /// How the image should be inscribed into the box.
  final BoxFit? boxfit;

  /// The color to apply to the image.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return BAAssetImage(
      boxFit: boxfit,
      type: ImageLoaderType.assetSVG,
      path: Assets.icons.icTransferMoney.path,
      width: BAResponsive.scale(context, defaultValue: width ?? 20),
      height: BAResponsive.scale(context, defaultValue: height ?? 20),
      color: color ?? context.colorScheme.onPrimary,
    );
  }
}

/// A widget for displaying the electric bill icon.
class _BAElectricBillImage extends StatelessWidget {
  /// Creates a [_BAElectricBillImage] widget.
  const _BAElectricBillImage({
    this.width,
    this.height,
    this.boxfit,
    this.color,
  });

  /// The height of the image.
  final double? height;

  /// The width of the image.
  final double? width;

  /// How the image should be inscribed into the box.
  final BoxFit? boxfit;

  /// The color to apply to the image.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return BAAssetImage(
      boxFit: boxfit,
      type: ImageLoaderType.assetSVG,
      path: Assets.icons.icElectric.path,
      width: BAResponsive.scale(context, defaultValue: width ?? 20),
      height: BAResponsive.scale(context, defaultValue: height ?? 20),
      color: color ?? context.colorScheme.onPrimary,
    );
  }
}

/// A widget for displaying the internet bill icon.
class _BAInternetBillImage extends StatelessWidget {
  /// Creates a [_BAInternetBillImage] widget.
  const _BAInternetBillImage({
    this.width,
    this.height,
    this.boxfit,
    this.color,
  });

  /// The height of the image.
  final double? height;

  /// The width of the image.
  final double? width;

  /// How the image should be inscribed into the box.
  final BoxFit? boxfit;

  /// The color to apply to the image.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return BAAssetImage(
      boxFit: boxfit,
      type: ImageLoaderType.assetSVG,
      path: Assets.icons.icInternet.path,
      width: BAResponsive.scale(context, defaultValue: width ?? 20),
      height: BAResponsive.scale(context, defaultValue: height ?? 20),
      color: color ?? context.colorScheme.onPrimary,
    );
  }
}

/// A widget for displaying the swap image.
class _BASwapImage extends StatelessWidget {
  /// Creates a [_BASwapImage] widget.
  const _BASwapImage({this.width, this.height, this.boxfit});

  /// The height of the image.
  final double? height;

  /// The width of the image.
  final double? width;

  /// How the image should be inscribed into the box.
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

/// A widget for displaying the message icon.
class _BAMessageImage extends StatelessWidget {
  /// Creates a [_BAMessageImage] widget.
  const _BAMessageImage({this.width, this.height, this.boxfit, this.color});

  /// The height of the image.
  final double? height;

  /// The width of the image.
  final double? width;

  /// How the image should be inscribed into the box.
  final BoxFit? boxfit;

  /// The color to apply to the image.
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

/// A widget for displaying the filled message icon.
class _BAMessageFilledImage extends StatelessWidget {
  /// Creates a [_BAMessageFilledImage] widget.
  const _BAMessageFilledImage({
    this.width,
    this.height,
    this.boxfit,
    this.color,
  });

  /// The height of the image.
  final double? height;

  /// The width of the image.
  final double? width;

  /// How the image should be inscribed into the box.
  final BoxFit? boxfit;

  /// The color to apply to the image.
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

/// A widget for displaying the settings icon.
class _BASettingImage extends StatelessWidget {
  /// Creates a [_BASettingImage] widget.
  const _BASettingImage({this.width, this.height, this.boxfit, this.color});

  /// The height of the image.
  final double? height;

  /// The width of the image.
  final double? width;

  /// How the image should be inscribed into the box.
  final BoxFit? boxfit;

  /// The color to apply to the image.
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

/// A widget for displaying the filled settings icon.
class _BASettingFilledImage extends StatelessWidget {
  /// Creates a [_BASettingFilledImage] widget.
  const _BASettingFilledImage({
    this.width,
    this.height,
    this.boxfit,
    this.color,
  });

  /// The height of the image.
  final double? height;

  /// The width of the image.
  final double? width;

  /// How the image should be inscribed into the box.
  final BoxFit? boxfit;

  /// The color to apply to the image.
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

/// A widget for displaying the lock driver image.
class _BALockDriveImage extends StatelessWidget {
  /// Creates a [_BALockDriveImage] widget.
  const _BALockDriveImage({this.width, this.height, this.boxfit});

  /// The height of the image.
  final double? height;

  /// The width of the image.
  final double? width;

  /// How the image should be inscribed into the box.
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

/// A widget for displaying the contacts image.
class _BAContactsImage extends StatelessWidget {
  /// Creates a [_BAContactsImage] widget.
  const _BAContactsImage({this.width, this.height, this.boxfit});

  /// The height of the image.
  final double? height;

  /// The width of the image.
  final double? width;

  /// How the image should be inscribed into the box.
  final BoxFit? boxfit;

  @override
  Widget build(BuildContext context) {
    return BAAssetImage(
      boxFit: boxfit,
      path: Assets.images.imgContacts.path,
      color: context.colorScheme.inverseSurface,
      width: BAResponsive.scale(context, defaultValue: width ?? 28),
      height: BAResponsive.scale(context, defaultValue: height ?? 28),
    );
  }
}

/// A widget for displaying the credit card image.
class _BACreditCardImage extends StatelessWidget {
  /// Creates a [_BACreditCardImage] widget.
  const _BACreditCardImage({this.width, this.height, this.boxfit});

  /// The height of the image.
  final double? height;

  /// The width of the image.
  final double? width;

  /// How the image should be inscribed into the box.
  final BoxFit? boxfit;

  @override
  Widget build(BuildContext context) {
    return BAAssetImage(
      boxFit: boxfit,
      path: Assets.images.imgCreditCard.path,
      color: context.colorScheme.inverseSurface,
      width: BAResponsive.scale(context, defaultValue: width ?? 28),
      height: BAResponsive.scale(context, defaultValue: height ?? 28),
    );
  }
}

/// A widget for displaying the credit card in image.
class _BACreditCardInImage extends StatelessWidget {
  /// Creates a [_BACreditCardInImage] widget.
  const _BACreditCardInImage({this.width, this.height, this.boxfit});

  /// The height of the image.
  final double? height;

  /// The width of the image.
  final double? width;

  /// How the image should be inscribed into the box.
  final BoxFit? boxfit;

  @override
  Widget build(BuildContext context) {
    return BAAssetImage(
      boxFit: boxfit,
      path: Assets.images.imgCreditCardIn.path,
      color: context.colorScheme.inverseSurface,
      width: BAResponsive.scale(context, defaultValue: width ?? 28),
      height: BAResponsive.scale(context, defaultValue: height ?? 28),
    );
  }
}

/// A widget for displaying the file paragraph image.
class _BAFileParagraphImage extends StatelessWidget {
  /// Creates a [_BAFileParagraphImage] widget.
  const _BAFileParagraphImage({this.width, this.height, this.boxfit});

  /// The height of the image.
  final double? height;

  /// The width of the image.
  final double? width;

  /// How the image should be inscribed into the box.
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

/// A widget for displaying the mobile banking image.
class _BAMobileBankingImage extends StatelessWidget {
  /// Creates a [_BAMobileBankingImage] widget.
  const _BAMobileBankingImage({this.width, this.height, this.boxfit});

  /// The height of the image.
  final double? height;

  /// The width of the image.
  final double? width;

  /// How the image should be inscribed into the box.
  final BoxFit? boxfit;

  @override
  Widget build(BuildContext context) {
    return BAAssetImage(
      boxFit: boxfit,
      path: Assets.images.imgMobileBanking.path,
      color: context.colorScheme.inverseSurface,
      width: BAResponsive.scale(context, defaultValue: width ?? 28),
      height: BAResponsive.scale(context, defaultValue: height ?? 28),
    );
  }
}

/// A widget for displaying the save online image.
class _BASaveOnlineImage extends StatelessWidget {
  /// Creates a [_BASaveOnlineImage] widget.
  const _BASaveOnlineImage({this.width, this.height, this.boxfit});

  /// The height of the image.
  final double? height;

  /// The width of the image.
  final double? width;

  /// How the image should be inscribed into the box.
  final BoxFit? boxfit;

  @override
  Widget build(BuildContext context) {
    return BAAssetImage(
      boxFit: boxfit,
      path: Assets.images.imgPig.path,
      color: context.colorScheme.inverseSurface,
      width: BAResponsive.scale(context, defaultValue: width ?? 28),
      height: BAResponsive.scale(context, defaultValue: height ?? 28),
    );
  }
}

/// A widget for displaying the beneficiary image.
class _BABeneficiaryImage extends StatelessWidget {
  /// Creates a [_BABeneficiaryImage] widget.
  const _BABeneficiaryImage({this.width, this.height, this.boxfit});

  /// The height of the image.
  final double? height;

  /// The width of the image.
  final double? width;

  /// How the image should be inscribed into the box.
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

/// A widget for displaying the pig image.
class _BAPigImage extends StatelessWidget {
  /// Creates a [_BAPigImage] widget.
  const _BAPigImage({this.width, this.height, this.boxfit});

  /// The height of the image.
  final double? height;

  /// The width of the image.
  final double? width;

  /// How the image should be inscribed into the box.
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

/// A widget for displaying the receipt image.
class _BAReceiptImage extends StatelessWidget {
  /// Creates a [_BAReceiptImage] widget.
  const _BAReceiptImage({this.width, this.height, this.boxfit});

  /// The height of the image.
  final double? height;

  /// The width of the image.
  final double? width;

  /// How the image should be inscribed into the box.
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

/// A widget for displaying the sync devices image.
class _BASyncDevicesImage extends StatelessWidget {
  /// Creates a [_BASyncDevicesImage] widget.
  const _BASyncDevicesImage({this.width, this.height, this.boxfit});

  /// The height of the image.
  final double? height;

  /// The width of the image.
  final double? width;

  /// How the image should be inscribed into the box.
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

/// A widget for displaying the wallet image.
class _BAWalletImage extends StatelessWidget {
  /// Creates a [_BAWalletImage] widget.
  const _BAWalletImage({this.width, this.height, this.boxfit});

  /// The height of the image.
  final double? height;

  /// The width of the image.
  final double? width;

  /// How the image should be inscribed into the box.
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

/// A widget for displaying the transfer success image.
class _BATransferSuccessImage extends StatelessWidget {
  /// Creates a [_BATransferSuccessImage] widget.
  const _BATransferSuccessImage({this.width, this.height, this.boxfit});

  /// The height of the image.
  final double? height;

  /// The width of the image.
  final double? width;

  /// How the image should be inscribed into the box.
  final BoxFit? boxfit;

  @override
  Widget build(BuildContext context) {
    return BAAssetImage(
      boxFit: boxfit,
      path: Assets.images.imgTransferSuccess.path,
      width: BAResponsive.scale(context, defaultValue: width ?? 342),
      height: BAResponsive.scale(context, defaultValue: height ?? 188),
    );
  }
}

/// A widget for displaying the empty image.
class _BAEmptyImage extends StatelessWidget {
  /// Creates a [_BAEmptyImage] widget.
  const _BAEmptyImage({this.width, this.height, this.boxfit});

  /// The height of the image.
  final double? height;

  /// The width of the image.
  final double? width;

  /// How the image should be inscribed into the box.
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

/// A widget for displaying the electric image.
class _BAElectricImage extends StatelessWidget {
  /// Creates a [_BAElectricImage] widget.
  const _BAElectricImage({this.width, this.height, this.boxfit});

  /// The height of the image.
  final double? height;

  /// The width of the image.
  final double? width;

  /// How the image should be inscribed into the box.
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

/// A widget for displaying the water image.
class _BAWaterImage extends StatelessWidget {
  /// Creates a [_BAWaterImage] widget.
  const _BAWaterImage({this.width, this.height, this.boxfit});

  /// The height of the image.
  final double? height;

  /// The width of the image.
  final double? width;

  /// How the image should be inscribed into the box.
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

/// A widget for displaying the internet image.
class _BAInternetImage extends StatelessWidget {
  /// Creates a [_BAInternetImage] widget.
  const _BAInternetImage({this.width, this.height, this.boxfit});

  /// The height of the image.
  final double? height;

  /// The width of the image.
  final double? width;

  /// How the image should be inscribed into the box.
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

/// A widget for displaying the fingerprint image.
class _BAFingerprintImage extends StatelessWidget {
  /// Creates a [_BAFingerprintImage] widget.
  const _BAFingerprintImage({this.width, this.height, this.boxfit});

  /// The height of the image.
  final double? height;

  /// The width of the image.
  final double? width;

  /// How the image should be inscribed into the box.
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

/// A widget for displaying the transaction success image.
class _BATransactionSuccessImage extends StatelessWidget {
  /// Creates a [_BATransactionSuccessImage] widget.
  const _BATransactionSuccessImage({this.width, this.height, this.boxfit});

  /// The height of the image.
  final double? height;

  /// The width of the image.
  final double? width;

  /// How the image should be inscribed into the box.
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

/// A widget for displaying the branch image.
class _BABranchImage extends StatelessWidget {
  /// Creates a [_BABranchImage] widget.
  const _BABranchImage({this.width, this.height, this.boxfit});

  /// The height of the image.
  final double? height;

  /// The width of the image.
  final double? width;

  /// How the image should be inscribed into the box.
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

/// A widget for displaying the interest image.
class _BAInterestImage extends StatelessWidget {
  /// Creates a [_BAInterestImage] widget.
  const _BAInterestImage({this.width, this.height, this.boxfit});

  /// The height of the image.
  final double? height;

  /// The width of the image.
  final double? width;

  /// How the image should be inscribed into the box.
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

/// A widget for displaying the exchange image.
class _BAExchangeImage extends StatelessWidget {
  /// Creates a [_BAExchangeImage] widget.
  const _BAExchangeImage({this.width, this.height, this.boxfit});

  /// The height of the image.
  final double? height;

  /// The width of the image.
  final double? width;

  /// How the image should be inscribed into the box.
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

/// A widget for displaying the exchange rate image.
class _BAExchangeRateImage extends StatelessWidget {
  /// Creates a [_BAExchangeRateImage] widget.
  const _BAExchangeRateImage({this.width, this.height, this.boxfit});

  /// The height of the image.
  final double? height;

  /// The width of the image.
  final double? width;

  /// How the image should be inscribed into the box.
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

/// A widget for displaying the exchange money image.
class _BAExchangeMoneyImage extends StatelessWidget {
  /// Creates a [_BAExchangeMoneyImage] widget.
  const _BAExchangeMoneyImage({this.width, this.height, this.boxfit});

  /// The height of the image.
  final double? height;

  /// The width of the image.
  final double? width;

  /// How the image should be inscribed into the box.
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

/// A widget for displaying a user's profile image.
///
/// This widget displays a circular avatar of the user's profile image.
/// If the URL is null or empty, a fallback avatar with a person icon is displayed.

class BAProfileImage extends StatelessWidget {
  /// Creates a [BAProfileImage] widget.
  const BAProfileImage({
    super.key,
    this.url,
    this.filePath,
    this.size = 50,
    this.backgroundColor,
    this.iconColor = Colors.white,
  });

  /// The URL of the profile image (for network images).
  final String? url;

  /// The file path of the profile image (for local files).
  final String? filePath;

  /// The size of the avatar.
  final double size;

  /// Background color of the avatar.
  final Color? backgroundColor;

  /// Icon color for fallback avatar.
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    // Prioritize handling URLs first
    if (url != null && url!.isNotEmpty) {
      // If the URL points to a local file (starts with "/" or "file://")
      if (url!.startsWith('/') || url!.startsWith('file://')) {
        return _buildFileImage(url!);
      }

      // Otherwise, treat it as a network image
      return _buildNetworkImage(url!);
    }

    // If no URL but a file path is provided, load the local file
    if (filePath != null && filePath!.isNotEmpty) {
      return _buildFileImage(filePath!);
    }

    // If neither URL nor file path is available, show fallback avatar
    return _fallbackAvatar();
  }

  /// Builds a file image from local storage
  Widget _buildFileImage(String path) {
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: backgroundColor,
      child: ClipOval(
        child: Image.file(
          File(path),
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Icon(Icons.person, size: size * 0.6, color: iconColor);
          },
        ),
      ),
    );
  }

  /// Builds a network image
  Widget _buildNetworkImage(String imageUrl) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => CircleAvatar(
        radius: size / 2,
        backgroundColor: backgroundColor,
        backgroundImage: imageProvider,
      ),
      placeholder: (context, _) => _placeholderAvatar(),
      errorWidget: (context, _, __) => _fallbackAvatar(),
    );
  }

  /// Placeholder while loading image
  Widget _placeholderAvatar() {
    return CircleAvatar(
      radius: size / 2,
      backgroundColor:
          backgroundColor?.withAlpha(50) ?? Colors.grey.withAlpha(50),
    );
  }

  /// Returns a fallback avatar when image is unavailable
  Widget _fallbackAvatar() {
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: backgroundColor,
      child: Icon(Icons.person, size: size * 0.6, color: iconColor),
    );
  }
}
