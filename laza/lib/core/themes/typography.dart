import 'package:flutter/material.dart';
import 'package:laza/core/gen_assets/fonts.gen.dart';
import 'package:laza/core/themes/colors.dart';

class LSUiTypographyFoundation {
  LSUiTypographyFoundation._();

  // Font size 11, regular
  static final TextStyle captionTextStyle = _defaultTextStyle.copyWith(
    fontSize: 11,
  );

  // Font size 11, medium
  static final TextStyle caption1TextStyle = _defaultTextStyle.copyWith(
    fontSize: 11,
    fontWeight: FontWeight.w500,
  );

  // Font size 13, regular
  static final TextStyle caption2TextStyle = _defaultTextStyle.copyWith(
    fontSize: 13,
  );

  // Font size 13, medium
  static final TextStyle caption3TextStyle = _defaultTextStyle.copyWith(
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );

  // Font size 13, medium
  static final TextStyle caption4TextStyle = _defaultTextStyle.copyWith(
    fontSize: 13,
    fontWeight: FontWeight.w600,
  );

  // Font size 15, regular
  static const TextStyle headlineNormalTextStyle = _defaultTextStyle;

  // Font size 15, medium
  static final TextStyle headlineMediumTextStyle = _defaultTextStyle.copyWith(
    fontSize: 15,
    fontWeight: FontWeight.w500,
  );

  // Font size 17, medium
  static final TextStyle textMediumTextStyle = _defaultTextStyle.copyWith(
    fontSize: 17,
    fontWeight: FontWeight.w500,
  );

  // Font size 17, semi-bold
  static final TextStyle textNormalTextStyle = _defaultTextStyle.copyWith(
    fontSize: 17,
    fontWeight: FontWeight.w600,
  );

  // Font size 28, semi-bold
  static final TextStyle title1TextStyle = _defaultTextStyle.copyWith(
    fontSize: 28,
    fontWeight: FontWeight.w600,
  );
  // Font size 22, semi-bold
  static final TextStyle title2TextStyle = _defaultTextStyle.copyWith(
    fontSize: 22,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle _defaultTextStyle = TextStyle(
    fontSize: 15,
    fontFamily: LSUiTypography.familyInter,
    fontWeight: FontWeight.w400,
    color: LSColors.mostlyBlack,
  );
}

class LSUiTypography {
  LSUiTypography._();
  // Fonts
  static const String familyInter = FontFamily.inter;
}
