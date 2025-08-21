import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/material.dart';

import '../../utils/colors.dart';

enum SnackbarStyle { error, success, normal, validationError }

extension SnackbarStyleExtension on SnackbarStyle {
  Color get displayTitleColor {
    switch (this) {
      case SnackbarStyle.error:
        return AppColors.white;
      case SnackbarStyle.success:
        return AppColors.white;
      case SnackbarStyle.normal:
        return AppColors.white;
      case SnackbarStyle.validationError:
        return AppColors.white;
    }
  }

  Color displayBackgroundColor(BuildContext context) {
    switch (this) {
      case SnackbarStyle.error:
        return AppColors.colorC4A6B5;
      case SnackbarStyle.success:
        return AppColors.color437986;
      case SnackbarStyle.normal:
        return Theme.of(context).colorScheme.primaryElementColor;
      case SnackbarStyle.validationError:
        return AppColors.colorC4A6B5;
    }
  }
}
