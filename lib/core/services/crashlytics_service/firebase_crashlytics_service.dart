import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

import 'crashlytics_service.dart';

class FirebaseCrashlyticsService implements CrashlyticsService {
  FirebaseCrashlyticsService();

  @override
  Future<void> recordError(dynamic exception, StackTrace? stack,
      {dynamic reason,
      Iterable<Object> information = const [],
      bool? printDetails,
      bool fatal = false}) {
    return FirebaseCrashlytics.instance
        .recordError(exception, stack, fatal: fatal);
  }

  @override
  Future<void> recordFlutterFatalError(
      FlutterErrorDetails flutterErrorDetails) {
    return FirebaseCrashlytics.instance
        .recordFlutterFatalError(flutterErrorDetails);
  }
}
