import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_palette.dart';
import 'typography.dart';

class BATheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: AppPalette.lightColorScheme,
      textTheme: AppTypography.textTheme,
      fontFamily: AppTypography.fontFamily,

      // AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: BAAppColors.surface,
        foregroundColor: BAAppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: BAAppColors.shadowLight,
        titleTextStyle: AppTypography.heading4,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        centerTitle: true,
        iconTheme: IconThemeData(color: BAAppColors.textPrimary, size: 24),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: BAAppColors.surface,
        shadowColor: BAAppColors.shadow,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: BAAppColors.primary,
          foregroundColor: BAAppColors.white,
          elevation: 2,
          shadowColor: BAAppColors.shadow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: AppTypography.buttonMedium,
          minimumSize: const Size(120, 48),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: BAAppColors.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: AppTypography.buttonMedium.copyWith(
            color: BAAppColors.primary,
          ),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: BAAppColors.primary,
          side: const BorderSide(color: BAAppColors.border, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: AppTypography.buttonMedium.copyWith(
            color: BAAppColors.primary,
          ),
          minimumSize: const Size(120, 48),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: BAAppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: BAAppColors.border, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: BAAppColors.border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: BAAppColors.borderFocus,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: BAAppColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: BAAppColors.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: BAAppColors.textTertiary,
        ),
        labelStyle: AppTypography.labelMedium,
        floatingLabelStyle: AppTypography.labelMedium.copyWith(
          color: BAAppColors.primary,
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: BAAppColors.surface,
        selectedItemColor: BAAppColors.primary,
        unselectedItemColor: BAAppColors.textTertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: AppTypography.tabLabel,
        unselectedLabelStyle: AppTypography.tabLabel,
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: BAAppColors.grey100,
        selectedColor: BAAppColors.primary,
        labelStyle: AppTypography.labelMedium,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),

      // Bottom Sheet Theme
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: BAAppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        elevation: 8,
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: BAAppColors.primary,
        foregroundColor: BAAppColors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),

      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return BAAppColors.white;
          }
          return BAAppColors.grey400;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return BAAppColors.primary;
          }
          return BAAppColors.grey300;
        }),
      ),

      // Radio Theme
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return BAAppColors.primary;
          }
          return BAAppColors.grey400;
        }),
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: BAAppColors.border,
        thickness: 1,
        space: 1,
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: BAAppColors.textSecondary,
        size: 24,
      ),

      // Primary Icon Theme
      primaryIconTheme: const IconThemeData(
        color: BAAppColors.primary,
        size: 24,
      ),

      // Scaffold Background Color
      scaffoldBackgroundColor: BAAppColors.background,

      // Splash Color
      splashColor: BAAppColors.primary.withOpacity(0.1),
      highlightColor: BAAppColors.primary.withOpacity(0.05),

      // Visual Density
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }

  static ThemeData get darkTheme {
    return lightTheme.copyWith(
      colorScheme: AppPalette.darkColorScheme,
      scaffoldBackgroundColor: const Color(0xFF121212),
      // Add more dark theme customizations as needed
    );
  }

  // Custom extensions for theme data
  static const double borderRadius = 12.0;
  static const double cardBorderRadius = 16.0;
  static const double buttonBorderRadius = 12.0;

  static const EdgeInsets defaultPadding = EdgeInsets.all(16.0);
  static const EdgeInsets smallPadding = EdgeInsets.all(8.0);
  static const EdgeInsets largePadding = EdgeInsets.all(24.0);

  static const double defaultElevation = 2.0;
  static const double cardElevation = 4.0;
  static const double modalElevation = 8.0;
}
