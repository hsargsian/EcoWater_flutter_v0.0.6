import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

class HealthService {
  factory HealthService() {
    return _instance;
  }

  HealthService._internal();

  static final HealthService _instance = HealthService._internal();

  List<HealthDataType> get types => (Platform.isAndroid)
      ? [HealthDataType.WATER]
      : (Platform.isIOS)
          ? [HealthDataType.WATER]
          : [];
  List<RecordingMethod> recordingMethodsToFilter = [];

  List<HealthDataAccess> get permissions => types
      .map((type) =>
          // can only request READ permissions to the following list of types on iOS
          [
            HealthDataType.WALKING_HEART_RATE,
            HealthDataType.ELECTROCARDIOGRAM,
            HealthDataType.HIGH_HEART_RATE_EVENT,
            HealthDataType.LOW_HEART_RATE_EVENT,
            HealthDataType.IRREGULAR_HEART_RATE_EVENT,
            HealthDataType.EXERCISE_TIME,
          ].contains(type)
              ? HealthDataAccess.READ
              : HealthDataAccess.READ_WRITE)
      .toList();

  void initalizeService() {
    Health().configure();
    Health().getHealthConnectSdkStatus();
  }

  Future<void> installHealthConnect() async => Health().installHealthConnect();

  Future<bool> authorize() async {
    await Permission.activityRecognition.request();
    await Permission.location.request();

    if (Platform.isAndroid) {
      final healthConnectAvailable = await Health().isHealthConnectAvailable();
      if (!healthConnectAvailable) {
        unawaited(installHealthConnect());
        // return false;
      } else {
        // return healthConnectAvailable;
      }
    }

    final hasPermissions = await Health().hasPermissions(types, permissions: permissions) ?? false;
    // hasPermissions = false;
    var authorized = false;
    if (!hasPermissions) {
      try {
        authorized = await Health().requestAuthorization(types, permissions: permissions);
      } catch (error) {
        debugPrint('Exception in authorize: $error');
      }
    }
    return authorized;
  }

  Future<void> revokeAccess() async {
    try {
      await Health().revokePermissions();
    } catch (error) {
      debugPrint('Exception in revokeAccess: $error');
    }
  }

  Future<bool> addWaterData(double amount) async {
    final now = DateTime.now();
    final earlier = now.subtract(const Duration(minutes: 20));

    var success = true;
    try {
      success &= await Health().writeHealthData(
          value: amount * 0.0295735,
          type: HealthDataType.WATER,
          unit: HealthDataUnit.LITER,
          startTime: earlier,
          endTime: now,
          recordingMethod: RecordingMethod.manual);
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('Error writing health data: $e');
        print(stackTrace);
      }
    }

    if (kDebugMode) {
      print(success);
    }
    return success;
  }
}
