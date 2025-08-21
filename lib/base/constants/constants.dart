import 'package:flutter/foundation.dart';
import 'package:table_calendar/table_calendar.dart';

abstract class Constants {
  static const appName = 'Echo Water';
  static const hasAppScreenSheild = 1;
  static const showsInternetConnectivitySheild = true;
  static const inAppNotificationDuration = 3;
  static const snackbarDuration = 4;
  static const imageQuality = 80;
  static const version = '0.0.1';
  static const buildNumber = 1;
  static const hasVibrationEnabled = false;
  static const defaultH2Value = 12;
  static const defaultWaterOuncesValue = 32;
  static const flaskCleanDuration = kDebugMode ? 10 : 600; //
  static const defaultCalendarView = CalendarFormat.week;
  static const defaultWakeFromSleepTime = 10;
  static const defaultFlaskVolume = 0;
  static const echowaterUrl = 'https://echowater.com/';
  static const guideLink = 'https://cdn.shopify.com/s/files/1/0828/0083/6914/files/User_Guide_Flask.pdf';
}
