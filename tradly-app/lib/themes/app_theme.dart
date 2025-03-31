import 'package:flutter/material.dart';
import 'package:tradly_app/themes/app_colors.dart';
import 'package:tradly_app/themes/typography.dart';

class TaTheme {
  static ThemeData get light {
    final defaultTheme = ThemeData.light(
      useMaterial3: true,
    );

    return defaultTheme.copyWith(
      colorScheme: TaColors.light,
      brightness: Brightness.light,

      /// AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: TaColors.light.primary,
        foregroundColor: TaColors.light.onPrimary,
        elevation: 0,
      ),

      /// Divider Theme
      dividerTheme: DividerThemeData(
        color: TaColors.light.outline,
        thickness: 1,
      ),

      /// Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: TaColors.light.surface,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: TaColors.light.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: TaColors.light.primary),
        ),
      ),

      /// Icon Theme
      iconTheme: IconThemeData(
        color: TaColors.light.onSurface,
      ),

      /// Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: TaColors.light.primary,
          foregroundColor: TaColors.light.onPrimary,
        ),
      ),

      /// Text Theme
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: TaTypography.fontSizeDisplayLarge,
          fontFamily: TaTypography.familyMontserrat,
        ),
        headlineSmall: TextStyle(
          fontSize: TaTypography.fontSizeHeadlineSmall,
          fontFamily: TaTypography.familyMontserrat,
        ),
        titleLarge: TextStyle(
          fontSize: TaTypography.fontSizeTitleLarge,
          fontFamily: TaTypography.familyMontserrat,
        ),
        labelLarge: TextStyle(
          fontSize: TaTypography.fontSizeLabelLarge,
          fontFamily: TaTypography.familyMontserrat,
        ),
      ),
    );
  }

  static ThemeData get dark {
    final defaultTheme = ThemeData.dark(
      useMaterial3: true,
    );

    return defaultTheme.copyWith(
      colorScheme: TaColors.dark,
      brightness: Brightness.dark,

      /// AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: TaColors.dark.primary,
        foregroundColor: TaColors.dark.onPrimary,
        elevation: 0,
      ),

      /// Divider Theme
      dividerTheme: DividerThemeData(
        color: TaColors.dark.outline,
        thickness: 1,
      ),

      /// Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: TaColors.dark.surface,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: TaColors.dark.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: TaColors.dark.primary),
        ),
      ),

      /// Icon Theme
      iconTheme: IconThemeData(
        color: TaColors.dark.onSurface,
      ),

      /// Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: TaColors.dark.primary,
          foregroundColor: TaColors.dark.onPrimary,
        ),
      ),

      /// Text Theme
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: TaTypography.fontSizeDisplayLarge,
          fontFamily: TaTypography.familyMontserrat,
        ),
        headlineSmall: TextStyle(
          fontSize: TaTypography.fontSizeHeadlineSmall,
          fontFamily: TaTypography.familyMontserrat,
        ),
        titleLarge: TextStyle(
          fontSize: TaTypography.fontSizeTitleLarge,
          fontFamily: TaTypography.familyMontserrat,
        ),
        labelLarge: TextStyle(
          fontSize: TaTypography.fontSizeLabelLarge,
          fontFamily: TaTypography.familyMontserrat,
        ),
      ),
    );
  }
}
