import 'package:flutter/material.dart';

class TaPalette {
  static const MaterialColor green = MaterialColor(
    0xFF33907C,
    <int, Color>{
      50: Color(0xFFE6F4F1),
      100: Color(0xFFCCE9E3),
      200: Color(0xFF99D3C7),
      300: Color(0xFF66BDAA),
      400: Color(0xFF33A78E),
      500: Color(0xFF33907C), // Primary green
      600: Color(0xFF2E826F),
      700: Color(0xFF297462),
      800: Color(0xFF246655),
      900: Color(0xFF1F5848),
    },
  );
  static const MaterialColor pink = MaterialColor(
    0xFFFF7272,
    <int, Color>{
      500: Color(0xFFFF7272),
    },
  );
  static const MaterialColor grey = MaterialColor(
    0xFF4F4F4F,
    <int, Color>{
      5: Color(0xFF4F4F4F),
    },
  );

  // Additional colors
  static const Color genericWhite = Color(0xFFFFFFFF);
  static const Color genericBlack = Color(0xFF000000);
  static const Color primaryRed = Color(0xFFCC0000);
  static const Color greyDark = Color(0xFFC4C4C4);
}
