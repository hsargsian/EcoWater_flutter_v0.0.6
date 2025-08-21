import 'package:echowater/base/utils/colors.dart';
import 'package:flutter/material.dart';

class AppStyles {
  AppStyles._();

  static OutlineInputBorder outlinedInputBorder(
          {bool hasValidationError = false,
          bool hasMandatoryBorder = false,
          Color borderColor = AppColors.transparent,
          double borderRadius = 16.0}) =>
      OutlineInputBorder(
        borderSide: BorderSide(
            width: hasMandatoryBorder ? 1.0 : (hasValidationError ? 1.0 : 0.0),
            color: hasValidationError ? AppColors.redColor : borderColor),
        borderRadius: BorderRadius.circular(borderRadius),
      );

  static OutlineInputBorder textViewBorder() => OutlineInputBorder(
        borderSide: const BorderSide(width: 0, color: AppColors.transparent),
        borderRadius: BorderRadius.circular(0),
      );

  static BorderSide borderside() =>
      BorderSide(color: AppColors.color717171, width: 0.5);
  static Border verticalAppBorder() => Border(
      top: BorderSide(color: AppColors.color717171, width: 0.5),
      bottom: BorderSide(color: AppColors.color717171, width: 0.5));
  static Border bottomAppBorder() =>
      Border(bottom: BorderSide(color: AppColors.color717171, width: 0.5));

  static BoxDecoration bottomSheetBoxDecoration(BuildContext context) =>
      BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(1, -1), // changes position of shadow
            )
          ],
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)));
}
