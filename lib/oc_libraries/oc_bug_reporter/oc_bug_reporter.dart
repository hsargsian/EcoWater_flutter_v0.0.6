import 'dart:io';

import 'package:alice/utils/shake_detector.dart';
import 'package:dio/dio.dart';
import 'package:echowater/core/domain/repositories/user_repository.dart';
import 'package:echowater/core/injector/injector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';

import '../device_information_retrieval/device_information_retrieval_service.dart';
import '../device_information_retrieval/device_information_retrieval_service_impl.dart';
import 'oc_bug_reporter_screen.dart';

class OCBugReporterService {
  factory OCBugReporterService() {
    _instance ??= OCBugReporterService._internal();
    return _instance!;
  }
  OCBugReporterService._internal();

  ShakeDetector? _shakeDetector;
  final ScreenshotController screenshotController = ScreenshotController();
  bool _hasLoggerOpened = false;
  static OCBugReporterService? _instance;
  late final DeviceInformationRetrievalService _deviceInfoService;

  late final GlobalKey<NavigatorState>? _navigatorKey;
  late final String _listId;
  late final String _apiKey;
  UserRepository? _userRepository;

  void Function(bool flag)? showsReporter;

  Future<void> initService(
      {required GlobalKey<NavigatorState>? key,
      required String listId,
      required String apiKey,
      required bool showsOnShake}) async {
    _deviceInfoService = await DeviceInformationRetrievalServiceImpl.init();

    _navigatorKey = key;
    _listId = listId;
    _apiKey = apiKey;

    if (showsOnShake) {
      if (Platform.isAndroid || Platform.isIOS) {
        _shakeDetector = ShakeDetector.autoStart(
          onPhoneShake: openLogger,
          shakeThresholdGravity: 4,
        );
      }
    }
    return Future.value();
  }

  BuildContext? getContext() => _navigatorKey?.currentState?.overlay?.context;

  void openLogger() {
    if (_hasLoggerOpened) {
      return;
    }
    screenshotController.capture().then((image) async {
      if (getContext() != null) {
        _openLogger(image);
      }
    }).catchError((onError) {
      if (kDebugMode) {
        print(onError);
      }
    });
  }

  void _openLogger(Uint8List? image) {
    if (_hasLoggerOpened) {
      return;
    }
    _hasLoggerOpened = true;
    showsReporter?.call(!_hasLoggerOpened);
    Navigator.push(
        getContext()!,
        OCBugReporterScreen.route(image, () {
          _hasLoggerOpened = false;
          showsReporter?.call(!_hasLoggerOpened);
        }));
  }

  Future<void> createLog(
      Uint8List? image, String title, String description) async {
    _userRepository ??= Injector.instance<UserRepository>();
    final apiUrl = 'https://api.clickup.com/api/v2/list/$_listId/task';
    try {
      final dio = Dio()..options.headers['Authorization'] = _apiKey;
      final deviceInformation =
          await _deviceInfoService.fetchDeviceInformation();
      final packageInformation =
          await _deviceInfoService.fetchPackageInformation();
      var detailedDescription =
          '''$description\n\nAppInformation:\nApp Name: ${packageInformation.appName}\nPackage Name: ${packageInformation.packageName}\nApp Version: ${packageInformation.versionName}\nBuild Number: ${packageInformation.buildNumber}\n\nDevice Information:\nDevice Version: ${packageInformation.versionName}\nModel: ${deviceInformation.model}\nDevice Platform: ${deviceInformation.platform}''';

      final userEntity = await _userRepository?.getCurrentUserFromCache();
      if (userEntity != null) {
        final user = userEntity.toDomain(true);
        detailedDescription =
            '$detailedDescription\n\n User:\nId: ${user.id}\nName: ${user.name}\nEmail:${user.email}\nPhone:${user.phoneNumber}';
      }
      final data = <String, dynamic>{
        'name': title,
        'description': detailedDescription,
        'tags': <String>[deviceInformation.platform]
      };

      final response = await dio.post(apiUrl, data: data);
      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        final id = responseData['id'] as String;
        _uploadAttachement(image, id);
      } else {
        if (kDebugMode) {
          print('Task creation failed');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

  void _uploadAttachement(Uint8List? image, String taskId) {
    final apiUrl = 'https://api.clickup.com/api/v2/task/$taskId/attachment';
    try {
      final dio = Dio()..options.headers['Authorization'] = _apiKey;
      final formData = FormData.fromMap(<String, dynamic>{
        'attachment': MultipartFile.fromBytes(image!,
            filename: 'your_attachment_filename.png'),
      });

      dio.post(apiUrl, data: formData);
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }
}
