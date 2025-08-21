import 'package:flutter/foundation.dart';

class DatePickerUtil {
  DatePickerUtil._();

  static bool isAndroid() {
    return defaultTargetPlatform == TargetPlatform.android;
  }
}
