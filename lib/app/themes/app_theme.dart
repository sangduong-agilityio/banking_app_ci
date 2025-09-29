import 'package:banking_app/app/themes/app_colors.dart';
import 'package:banking_app/app/themes/app_palette.dart';
import 'package:banking_app/app/themes/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BATheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: AppPalette.lightColorScheme,
      textTheme: BATypography.getLightTextTheme(),
      fontFamily: BATypography.familyPoppins,

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: BAAppColors.surface,
        foregroundColor: BAAppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: BAAppColors.shadowLight,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: BAAppColors.textPrimary,
          size: 24,
        ),
        titleTextStyle: BATypography.getLightTextTheme().titleLarge?.copyWith(
          color: BAAppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
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
          minimumSize: const Size(120, 48),
          textStyle: BATypography.getLightTextTheme().labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: BAAppColors.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: BATypography.getLightTextTheme().labelLarge?.copyWith(
            fontWeight: FontWeight.w500,
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
          minimumSize: const Size(120, 48),
          textStyle: BATypography.getLightTextTheme().labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
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
        labelStyle: BATypography.getLightTextTheme().bodyMedium,
        hintStyle: BATypography.getLightTextTheme().bodyMedium?.copyWith(
          color: BAAppColors.textTertiary,
        ),
        helperStyle: BATypography.getLightTextTheme().bodySmall,
        errorStyle: BATypography.getLightTextTheme().bodySmall?.copyWith(
          color: BAAppColors.error,
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: BAAppColors.surface,
        selectedItemColor: BAAppColors.primary,
        unselectedItemColor: BAAppColors.textTertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: BATypography.getLightTextTheme().labelSmall
            ?.copyWith(fontWeight: FontWeight.w600),
        unselectedLabelStyle: BATypography.getLightTextTheme().labelSmall,
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: BAAppColors.grey100,
        selectedColor: BAAppColors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        labelStyle: BATypography.getLightTextTheme().labelMedium,
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
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return BAAppColors.white;
          }
          return BAAppColors.grey400;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return BAAppColors.primary;
          }
          return BAAppColors.grey300;
        }),
      ),

      // Radio Theme
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
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

      // Visual Density
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }

  static ThemeData get darkTheme {
    return lightTheme.copyWith(
      colorScheme: AppPalette.darkColorScheme,
      scaffoldBackgroundColor: const Color(0xFF121212),

      // Add Dark Text Theme
      textTheme: BATypography.getDarkTextTheme(),

      // Update AppBar for dark theme
      appBarTheme: lightTheme.appBarTheme.copyWith(
        backgroundColor: const Color(0xFF1F1F1F),
        foregroundColor: Colors.white,
        titleTextStyle: BATypography.getDarkTextTheme().titleLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(color: Colors.white, size: 24),
      ),

      // Update other themes for dark mode as needed
      cardTheme: lightTheme.cardTheme.copyWith(color: const Color(0xFF1F1F1F)),
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

// Extension for easy access to text styles
extension TextThemeExtension on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;

  // Quick access to common text styles
  TextStyle? get displayLarge => textTheme.displayLarge;
  TextStyle? get displayMedium => textTheme.displayMedium;
  TextStyle? get displaySmall => textTheme.displaySmall;

  TextStyle? get headlineLarge => textTheme.headlineLarge;
  TextStyle? get headlineMedium => textTheme.headlineMedium;
  TextStyle? get headlineSmall => textTheme.headlineSmall;

  TextStyle? get titleLarge => textTheme.titleLarge;
  TextStyle? get titleMedium => textTheme.titleMedium;
  TextStyle? get titleSmall => textTheme.titleSmall;

  TextStyle? get bodyLarge => textTheme.bodyLarge;
  TextStyle? get bodyMedium => textTheme.bodyMedium;
  TextStyle? get bodySmall => textTheme.bodySmall;

  TextStyle? get labelLarge => textTheme.labelLarge;
  TextStyle? get labelMedium => textTheme.labelMedium;
  TextStyle? get labelSmall => textTheme.labelSmall;
}
