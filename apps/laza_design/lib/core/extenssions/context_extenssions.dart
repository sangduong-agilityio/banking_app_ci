import 'package:flutter/material.dart';

extension ThemeContext on BuildContext {
  ThemeData get themeData => Theme.of(this);
  ColorScheme get colorScheme => themeData.colorScheme;
  TextTheme get textTheme => themeData.textTheme;
  InputDecorationTheme get inputTheme => themeData.inputDecorationTheme;
}

extension MediaQueryContext on BuildContext {
  MediaQueryData get mediaQueryData => MediaQuery.of(this);

  double get keyboardHeight => mediaQueryData.viewInsets.bottom;

  bool get isOpenKeyboard => keyboardHeight > 0;
}
