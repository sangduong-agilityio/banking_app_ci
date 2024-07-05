import 'package:flutter/material.dart';
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
