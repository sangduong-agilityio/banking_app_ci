import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppPalette {
  // Light Theme Palette
  static const ColorScheme lightColorScheme = ColorScheme.light(
    primary: BAAppColors.primary,
    onPrimary: BAAppColors.white,
    primaryContainer: BAAppColors.primaryLight,
    onPrimaryContainer: BAAppColors.textPrimary,
    secondary: BAAppColors.secondary,
    onSecondary: BAAppColors.white,
    secondaryContainer: BAAppColors.secondaryLight,
    onSecondaryContainer: BAAppColors.textPrimary,
    tertiary: BAAppColors.info,
    onTertiary: BAAppColors.white,
    error: BAAppColors.error,
    onError: BAAppColors.white,
    errorContainer: Color(0xFFFFEDED),
    onErrorContainer: BAAppColors.error,
    surface: BAAppColors.surface,
    onSurface: BAAppColors.textPrimary,
    onSurfaceVariant: BAAppColors.textSecondary,
    outline: BAAppColors.border,
    outlineVariant: BAAppColors.grey200,
    shadow: BAAppColors.shadow,
    scrim: BAAppColors.black,
    inverseSurface: BAAppColors.grey500,
    onInverseSurface: BAAppColors.white,
    inversePrimary: BAAppColors.primaryLight,
    surfaceTint: BAAppColors.primary,
  );

  // Dark Theme Palette (for future dark mode support)
  static const ColorScheme darkColorScheme = ColorScheme.dark(
    primary: BAAppColors.primaryLight,
    onPrimary: BAAppColors.textPrimary,
    primaryContainer: BAAppColors.primaryDark,
    onPrimaryContainer: BAAppColors.white,
    secondary: BAAppColors.secondaryLight,
    onSecondary: BAAppColors.textPrimary,
    secondaryContainer: BAAppColors.secondary,
    onSecondaryContainer: BAAppColors.white,
    tertiary: Color(0xFF60A5FA),
    onTertiary: BAAppColors.textPrimary,
    error: Color(0xFFFF6B6B),
    onError: BAAppColors.white,
    errorContainer: Color(0xFF8B0000),
    onErrorContainer: Color(0xFFFFCDD2),
    surface: Color(0xFF1E1E1E),
    onSurface: BAAppColors.white,
    onSurfaceVariant: BAAppColors.grey300,
    outline: BAAppColors.grey600,
    outlineVariant: BAAppColors.grey700,
    shadow: Color(0x80000000),
    scrim: BAAppColors.black,
    inverseSurface: BAAppColors.grey100,
    onInverseSurface: BAAppColors.textPrimary,
    inversePrimary: BAAppColors.primary,
    surfaceTint: BAAppColors.primaryLight,
  );
}
