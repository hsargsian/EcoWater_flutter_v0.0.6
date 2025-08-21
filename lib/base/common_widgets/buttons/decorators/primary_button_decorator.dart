import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/material.dart';

import '../app_button_state.dart';
import 'app_button_decorator.dart';

class PrimaryButtonDecorator extends AppButtonDecorator {
  PrimaryButtonDecorator({this.backgroundOpacity = 1});
  double backgroundOpacity = 1;

  @override
  Color getBackgroundColor(
      BuildContext context, AppButtonState appButtonState) {
    switch (appButtonState) {
      case AppButtonState.enabled:
        return Theme.of(context).primaryColor;

      case AppButtonState.tapped:
        return Theme.of(context).primaryColorDark;
      case AppButtonState.disabled:
        return Theme.of(context).primaryColorLight.withValues(alpha: 0.8);
    }
  }

  @override
  Color getTitleColor(BuildContext context, AppButtonState appButtonState) {
    return Theme.of(context).colorScheme.primaryElementColor;
  }
}
