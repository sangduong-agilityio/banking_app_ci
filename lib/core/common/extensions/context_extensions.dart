import 'package:flutter/material.dart';

/// Extension on BuildContext to provide easy access to ThemeData, ColorScheme, and TextTheme.
extension ThemeContext on BuildContext {
  ThemeData get themeData => Theme.of(this);
  ColorScheme get colorScheme => themeData.colorScheme;
  TextTheme get textTheme => themeData.textTheme;
}
