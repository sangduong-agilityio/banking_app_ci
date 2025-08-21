import 'package:flutter/material.dart';

class BAAppColors {
  // Primary Colors
  static const Color primary = Color(0xFF469FEF);
  static const Color primaryDark = Color(0xFF3B52E5);
  static const Color primaryLight = Color(0xFF6B7FFF);

  // Secondary Colors
  static const Color secondary = Color(0xFF3629B7);
  static const Color secondaryLight = Color(0xFF33DFBB);

  // Background Colors
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF8F9FA);
  static const Color surfaceVariant = Color(0xFFF5F6FA);
  static const Color surfaceLight = Color(0xFFFFFDFF);

  // Text Colors
  static const Color textPrimary = Color(0xFF1A1D29);
  static const Color textSecondary = Color(0xFF6C7278);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textDisabled = Color(0xFFCBCBCB);

  // Status Colors
  static const Color success = Color(0xFF52D5BA);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF0890FE);
  static const Color infoLight = Color(0xFFE5E2FF);

  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey50 = Color(0xFFF9FAFB);
  static const Color grey100 = Color(0xFFF3F4F6);
  static const Color grey200 = Color(0xFFF2F1F9);
  static const Color grey300 = Color(0xFFD1D5DB);
  static const Color grey400 = Color(0xFF9CA3AF);
  static const Color grey500 = Color(0xFF898989);
  static const Color grey600 = Color(0xFF4B5563);
  static const Color grey700 = Color(0xFFCACACA);
  static const Color grey800 = Color(0xFF343434);
  static const Color grey900 = Color(0xFF111827);

  // Border Colors
  static const Color border = Color(0xFFE5E7EB);
  static const Color borderFocus = Color(0xFF4C63FF);

  // Shadow Colors
  static const Color shadow = Color(0x1A000000);
  static const Color shadowLight = Color(0x0D000000);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.26, 0.65],
    colors: [Color(0xFF469FEF), Color(0xFF5C75F0), Color(0xFF6C56F0)],
  );
}
