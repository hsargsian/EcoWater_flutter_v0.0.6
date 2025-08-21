import 'package:flutter/material.dart';

import '../app_button_state.dart';

abstract class AppButtonDecorator {
  Color getBackgroundColor(BuildContext context, AppButtonState appButtonState);
  Color getTitleColor(BuildContext context, AppButtonState appButtonState);
}
