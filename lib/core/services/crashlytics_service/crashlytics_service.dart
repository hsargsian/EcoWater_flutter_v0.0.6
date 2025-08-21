import 'dart:async';

import 'package:flutter/foundation.dart';

abstract class CrashlyticsService {
  Future<void> recordError(dynamic exception, StackTrace? stack,
      {dynamic reason,
      Iterable<Object> information = const [],
      bool? printDetails,
      bool fatal = false});
  Future<void> recordFlutterFatalError(FlutterErrorDetails flutterErrorDetails);
}
