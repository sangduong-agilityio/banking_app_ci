import 'package:flutter/material.dart';
import 'package:laza/core/constant/constants.dart';
import 'package:laza/core/l10n/l10n_generated/l10n.dart';

extension ThemeContext on BuildContext {
  ThemeData get themeData => Theme.of(this);
  ColorScheme get colorScheme => themeData.colorScheme;
  TextTheme get textTheme => themeData.textTheme;
  InputDecorationTheme get inputTheme => themeData.inputDecorationTheme;
  S get text => S.of(this);
}

extension MediaQueryContext on BuildContext {
  MediaQueryData get mediaQueryData => MediaQuery.of(this);

  double get keyboardHeight => mediaQueryData.viewInsets.bottom;

  bool get isOpenKeyboard => keyboardHeight > 0;
}

extension MediaQuerySize on num {
  static final double tabletScreen = WidgetsBinding
          .instance.platformDispatcher.views.first.physicalSize.width /
      WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
  static final double heightScreen = WidgetsBinding
          .instance.platformDispatcher.views.first.physicalSize.height /
      WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

  double get ratioDesign {
    if (tabletScreen > 900) {
      // tablet landscape
      return (tabletScreen / DesignConstants.widthTabletLandscape);
    } else if (tabletScreen > 600) {
      // tablet portrait
      return (tabletScreen / DesignConstants.widthTabletPortrait);
    } else {
      // mobile
      return (tabletScreen / DesignConstants.widthMobile);
    }
  }

  // Using for dimension of horizontal (width, left, right)
  double get w => this * ratioDesign;

  // Using for dimension of vertical (height, top, bottom)
  double get h => this * ratioDesign;
}
