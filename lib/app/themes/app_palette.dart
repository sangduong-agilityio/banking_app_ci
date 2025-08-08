import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppPalette {
  // Light Theme Palette
  static const ColorScheme lightColorScheme = ColorScheme.light(
    primary: AppColors.primary,
    onPrimary: AppColors.white,
    primaryContainer: AppColors.primaryLight,
    onPrimaryContainer: AppColors.textPrimary,
    secondary: AppColors.secondary,
    onSecondary: AppColors.white,
    secondaryContainer: AppColors.secondaryLight,
    onSecondaryContainer: AppColors.textPrimary,
    tertiary: AppColors.info,
    onTertiary: AppColors.white,
    error: AppColors.error,
    onError: AppColors.white,
    errorContainer: Color(0xFFFFEDED),
    onErrorContainer: AppColors.error,
    surface: AppColors.surface,
    onSurface: AppColors.textPrimary,
    onSurfaceVariant: AppColors.textSecondary,
    outline: AppColors.border,
    outlineVariant: AppColors.grey200,
    shadow: AppColors.shadow,
    scrim: AppColors.black,
    inverseSurface: AppColors.grey800,
    onInverseSurface: AppColors.white,
    inversePrimary: AppColors.primaryLight,
    surfaceTint: AppColors.primary,
  );

  // Dark Theme Palette (for future dark mode support)
  static const ColorScheme darkColorScheme = ColorScheme.dark(
    primary: AppColors.primaryLight,
    onPrimary: AppColors.textPrimary,
    primaryContainer: AppColors.primaryDark,
    onPrimaryContainer: AppColors.white,
    secondary: AppColors.secondaryLight,
    onSecondary: AppColors.textPrimary,
    secondaryContainer: AppColors.secondary,
    onSecondaryContainer: AppColors.white,
    tertiary: Color(0xFF60A5FA),
    onTertiary: AppColors.textPrimary,
    error: Color(0xFFFF6B6B),
    onError: AppColors.white,
    errorContainer: Color(0xFF8B0000),
    onErrorContainer: Color(0xFFFFCDD2),
    surface: Color(0xFF1E1E1E),
    onSurface: AppColors.white,
    onSurfaceVariant: AppColors.grey300,
    outline: AppColors.grey600,
    outlineVariant: AppColors.grey700,
    shadow: Color(0x80000000),
    scrim: AppColors.black,
    inverseSurface: AppColors.grey100,
    onInverseSurface: AppColors.textPrimary,
    inversePrimary: AppColors.primary,

    surfaceTint: AppColors.primaryLight,
  );

  // Custom semantic colors for specific use cases
  static const Map<String, Color> semanticColors = {
    'cardBackground': AppColors.white,
    'inputBackground': AppColors.white,
    'inputBorder': AppColors.border,
    'inputBorderFocused': AppColors.borderFocus,
    'tabBarBackground': AppColors.surface,
    'tabBarActive': AppColors.primary,
    'tabBarInactive': AppColors.grey400,
    'transactionPositive': AppColors.success,
    'transactionNegative': AppColors.error,
    'balanceCard': AppColors.primary,
    'successBackground': Color(0xFFECFDF5),
    'warningBackground': Color(0xFFFEF3C7),
    'errorBackground': Color(0xFFFEF2F2),
    'infoBackground': Color(0xFFEFF6FF),
  };

  // Get semantic color helper
  static Color getSemanticColor(String key) {
    return semanticColors[key] ?? AppColors.primary;
  }
}
