import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract class BATypography {
  static const String familyPoppins = 'Poppins';

  // Display sizes - for main headings and hero text
  static const double fontSizeDisplayLarge = 32;
  static const double fontSizeDisplayMedium = 28;
  static const double fontSizeDisplaySmall = 24;

  // Headline sizes - for section headers
  static const double fontSizeHeadlineLarge = 22;
  static const double fontSizeHeadlineMedium = 20;
  static const double fontSizeHeadlineSmall = 18;

  // Title sizes - for card titles and important text
  static const double fontSizeTitleLarge = 18;
  static const double fontSizeTitleMedium = 16;
  static const double fontSizeTitleSmall = 14;

  // Body sizes - for general content
  static const double fontSizeBodyLarge = 16;
  static const double fontSizeBodyMedium = 14;
  static const double fontSizeBodySmall = 12;

  // Label sizes - for captions and small text
  static const double fontSizeLabelLarge = 14;
  static const double fontSizeLabelMedium = 12;
  static const double fontSizeLabelSmall = 10;

  // Text styles helper methods
  static TextStyle _getTextStyle({
    required double fontSize,
    required FontWeight fontWeight,
    required Color color,
    double? height,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontFamily: familyPoppins,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  // Light theme text styles
  static TextTheme getLightTextTheme() {
    return TextTheme(
      // Display styles
      displayLarge: _getTextStyle(
        fontSize: fontSizeDisplayLarge,
        fontWeight: FontWeight.w700,
        color: BAAppColors.textPrimary,
        height: 1.2,
        letterSpacing: -0.5,
      ),
      displayMedium: _getTextStyle(
        fontSize: fontSizeDisplayMedium,
        fontWeight: FontWeight.w700,
        color: BAAppColors.textPrimary,
        height: 1.2,
        letterSpacing: -0.25,
      ),
      displaySmall: _getTextStyle(
        fontSize: fontSizeDisplaySmall,
        fontWeight: FontWeight.w600,
        color: BAAppColors.textPrimary,
        height: 1.3,
      ),

      // Headline styles
      headlineLarge: _getTextStyle(
        fontSize: fontSizeHeadlineLarge,
        fontWeight: FontWeight.w600,
        color: BAAppColors.textPrimary,
        height: 1.3,
      ),
      headlineMedium: _getTextStyle(
        fontSize: fontSizeHeadlineMedium,
        fontWeight: FontWeight.w600,
        color: BAAppColors.textPrimary,
        height: 1.3,
      ),
      headlineSmall: _getTextStyle(
        fontSize: fontSizeHeadlineSmall,
        fontWeight: FontWeight.w600,
        color: BAAppColors.textPrimary,
        height: 1.4,
      ),

      // Title styles
      titleLarge: _getTextStyle(
        fontSize: fontSizeTitleLarge,
        fontWeight: FontWeight.w600,
        color: BAAppColors.textPrimary,
        height: 1.4,
      ),
      titleMedium: _getTextStyle(
        fontSize: fontSizeTitleMedium,
        fontWeight: FontWeight.w500,
        color: BAAppColors.textPrimary,
        height: 1.4,
      ),
      titleSmall: _getTextStyle(
        fontSize: fontSizeTitleSmall,
        fontWeight: FontWeight.w500,
        color: BAAppColors.textSecondary,
        height: 1.4,
      ),

      // Body styles
      bodyLarge: _getTextStyle(
        fontSize: fontSizeBodyLarge,
        fontWeight: FontWeight.w400,
        color: BAAppColors.textPrimary,
        height: 1.5,
      ),
      bodyMedium: _getTextStyle(
        fontSize: fontSizeBodyMedium,
        fontWeight: FontWeight.w400,
        color: BAAppColors.textSecondary,
        height: 1.5,
      ),
      bodySmall: _getTextStyle(
        fontSize: fontSizeBodySmall,
        fontWeight: FontWeight.w400,
        color: BAAppColors.textTertiary,
        height: 1.4,
      ),

      // Label styles
      labelLarge: _getTextStyle(
        fontSize: fontSizeLabelLarge,
        fontWeight: FontWeight.w500,
        color: BAAppColors.textSecondary,
        height: 1.4,
        letterSpacing: 0.1,
      ),
      labelMedium: _getTextStyle(
        fontSize: fontSizeLabelMedium,
        fontWeight: FontWeight.w500,
        color: BAAppColors.textTertiary,
        height: 1.3,
        letterSpacing: 0.5,
      ),
      labelSmall: _getTextStyle(
        fontSize: fontSizeLabelSmall,
        fontWeight: FontWeight.w500,
        color: BAAppColors.textTertiary,
        height: 1.2,
        letterSpacing: 0.5,
      ),
    );
  }

  // Dark theme text styles
  static TextTheme getDarkTextTheme() {
    return TextTheme(
      // Display styles
      displayLarge: _getTextStyle(
        fontSize: fontSizeDisplayLarge,
        fontWeight: FontWeight.w700,
        color: Colors.white,
        height: 1.2,
        letterSpacing: -0.5,
      ),
      displayMedium: _getTextStyle(
        fontSize: fontSizeDisplayMedium,
        fontWeight: FontWeight.w700,
        color: Colors.white,
        height: 1.2,
        letterSpacing: -0.25,
      ),
      displaySmall: _getTextStyle(
        fontSize: fontSizeDisplaySmall,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        height: 1.3,
      ),

      // Headline styles
      headlineLarge: _getTextStyle(
        fontSize: fontSizeHeadlineLarge,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        height: 1.3,
      ),
      headlineMedium: _getTextStyle(
        fontSize: fontSizeHeadlineMedium,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        height: 1.3,
      ),
      headlineSmall: _getTextStyle(
        fontSize: fontSizeHeadlineSmall,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        height: 1.4,
      ),

      // Title styles
      titleLarge: _getTextStyle(
        fontSize: fontSizeTitleLarge,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        height: 1.4,
      ),
      titleMedium: _getTextStyle(
        fontSize: fontSizeTitleMedium,
        fontWeight: FontWeight.w500,
        color: Colors.white,
        height: 1.4,
      ),
      titleSmall: _getTextStyle(
        fontSize: fontSizeTitleSmall,
        fontWeight: FontWeight.w500,
        color: Colors.white70,
        height: 1.4,
      ),

      // Body styles
      bodyLarge: _getTextStyle(
        fontSize: fontSizeBodyLarge,
        fontWeight: FontWeight.w400,
        color: Colors.white,
        height: 1.5,
      ),
      bodyMedium: _getTextStyle(
        fontSize: fontSizeBodyMedium,
        fontWeight: FontWeight.w400,
        color: Colors.white70,
        height: 1.5,
      ),
      bodySmall: _getTextStyle(
        fontSize: fontSizeBodySmall,
        fontWeight: FontWeight.w400,
        color: Colors.white60,
        height: 1.4,
      ),

      // Label styles
      labelLarge: _getTextStyle(
        fontSize: fontSizeLabelLarge,
        fontWeight: FontWeight.w500,
        color: Colors.white70,
        height: 1.4,
        letterSpacing: 0.1,
      ),
      labelMedium: _getTextStyle(
        fontSize: fontSizeLabelMedium,
        fontWeight: FontWeight.w500,
        color: Colors.white60,
        height: 1.3,
        letterSpacing: 0.5,
      ),
      labelSmall: _getTextStyle(
        fontSize: fontSizeLabelSmall,
        fontWeight: FontWeight.w500,
        color: Colors.white60,
        height: 1.2,
        letterSpacing: 0.5,
      ),
    );
  }
}
