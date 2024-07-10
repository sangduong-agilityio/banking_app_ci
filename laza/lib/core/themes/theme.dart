import 'package:flutter/material.dart';
import 'package:laza/core/color/colors.dart';
import 'package:laza/core/typography/typography.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData.light().copyWith(
    primaryColor: _lightColorScheme.primary,
    hintColor: _lightColorScheme.tertiary,
    colorScheme: _lightColorScheme,
    textTheme: _lightTextTheme,
    inputDecorationTheme: _inputDecorationTheme,
    searchBarTheme: _searchBarTheme,
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
        onTertiary: LSColors.grey400,
        outlineVariant: LSColors.grey200,
        outline: LSColors.grey100,
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

  /// InputDecorationTheme
  static final InputDecorationTheme _inputDecorationTheme =
      InputDecorationTheme(
    fillColor: _lightColorScheme.primary,
    errorBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        width: 1,
        color: _lightColorScheme.error,
      ),
    ),
    focusedErrorBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        width: 1,
        color: _lightColorScheme.outline,
      ),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(width: 1, color: _lightColorScheme.outline),
    ),
    errorStyle: LSUiTypographyFoundation.caption2TextStyle.copyWith(
      color: _lightColorScheme.error,
    ),
    hintStyle: LSUiTypographyFoundation.headlineMediumTextStyle
        .copyWith(color: _lightColorScheme.primaryContainer),
    border: UnderlineInputBorder(
        borderSide: BorderSide(color: _lightColorScheme.tertiary)),
    labelStyle: LSUiTypographyFoundation.headlineMediumTextStyle
        .copyWith(color: _lightColorScheme.tertiaryContainer),
  );

  /// SearchBarTheme
  static final SearchBarThemeData _searchBarTheme = SearchBarThemeData(
    elevation: WidgetStateProperty.all(0),
    textStyle: WidgetStatePropertyAll(
      _lightTextTheme.headlineMedium?.copyWith(
        color: _lightColorScheme.tertiaryContainer,
      ),
    ),
    backgroundColor:
        WidgetStatePropertyAll(_lightColorScheme.tertiaryContainer),
    hintStyle: WidgetStatePropertyAll(
      _lightTextTheme.headlineMedium?.copyWith(
        color: _lightColorScheme.tertiaryContainer,
      ),
    ),
    shape: WidgetStateProperty.all(
      const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
    ),
  );
}
