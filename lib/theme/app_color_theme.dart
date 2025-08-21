import 'package:flutter/material.dart';

import '../base/utils/colors.dart';

extension CustomColorScheme on ColorScheme {
  Color get primaryElementColor => brightness == Brightness.light
      ? AppColors.primaryElementColorLight
      : AppColors.primaryElementColorDark;

  Color get primaryElementColorInverted => brightness == Brightness.dark
      ? AppColors.primaryElementColorLight
      : AppColors.primaryElementColorDark;

  Color get secondaryElementColor => brightness == Brightness.light
      ? AppColors.secondaryElementColorLight
      : AppColors.secondaryElementColorDark;

  Color get tertiaryElementColor => brightness == Brightness.light
      ? AppColors.tertiaryElementColor
      : AppColors.white;

  Color get accentElementColor => brightness == Brightness.light
      ? AppColors.accentElementColor
      : AppColors.white;

  Color get successColor =>
      brightness == Brightness.light ? AppColors.green : AppColors.green;

  Color get primaryElementInvertedeColor => brightness == Brightness.light
      ? AppColors.primaryElementInvertedColor
      : AppColors.primaryElementInvertedColor;

  Color get appRed =>
      brightness == Brightness.light ? AppColors.redColor : AppColors.redColor;
  Color get appGreen =>
      brightness == Brightness.light ? AppColors.green : AppColors.green;
  Color get highLightColor => brightness == Brightness.light
      ? AppColors.primaryHighlightColorLight
      : AppColors.primaryHighlightColorDark;
}
