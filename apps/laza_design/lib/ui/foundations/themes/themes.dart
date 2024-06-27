import 'package:flutter/material.dart';
import 'package:laza_design/ui/foundations/colors.dart';
import 'package:laza_design/ui/foundations/typography.dart';

class AppTheme {
  // The light theme for application
  static final ThemeData lightTheme = ThemeData.light().copyWith(
    primaryColor: _lightColorScheme.primary,
    hintColor: _lightColorScheme.tertiary,
    colorScheme: _lightColorScheme,
    textTheme: _lightTextTheme,
  );

  // The darkThem for application
  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    textTheme: _lightTextTheme,
  );
  static ColorScheme get _lightColorScheme => const ColorScheme(
        brightness: Brightness.light,
        primary: LSColors.primary600,
        onPrimary: LSColors.white,
        primaryContainer: LSColors.black,
        onPrimaryContainer: LSColors.primary700,
        secondary: LSColors.mostlyBlack,
        onSecondary: LSColors.white,
        tertiaryContainer: LSColors.grey500,
        error: LSColors.error600,
        onError: LSColors.error300,
        surface: LSColors.grey50,
        onSurface: LSColors.grey800,
        inverseSurface: LSColors.grey700,
        onSurfaceVariant: LSColors.primary500,
      );

  static final TextTheme _lightTextTheme = TextTheme(
    // Font size 28, semi-bold
    displayLarge: LSUiTypographyFoundation.title1TextStyle.copyWith(
      color: _lightColorScheme.primaryContainer,
    ),
    // Font size 22, semi-bold
    displayMedium: LSUiTypographyFoundation.title2TextStyle.copyWith(
      color: _lightColorScheme.primaryContainer,
    ),
    // Font size 17, medium
    headlineLarge: LSUiTypographyFoundation.textMediumTextStyle.copyWith(
      color: _lightColorScheme.primaryContainer,
    ),
    // Font size 15, regular
    headlineMedium: LSUiTypographyFoundation.headlineNormalTextStyle.copyWith(
      color: _lightColorScheme.tertiaryContainer,
    ),
    // Font size 13, regular
    bodyLarge: LSUiTypographyFoundation.caption2TextStyle.copyWith(
      color: _lightColorScheme.tertiaryContainer,
    ),
    // Font size 11, medium
    titleMedium: LSUiTypographyFoundation.caption1TextStyle.copyWith(
      color: _lightColorScheme.tertiaryContainer,
    ),
  );
}
