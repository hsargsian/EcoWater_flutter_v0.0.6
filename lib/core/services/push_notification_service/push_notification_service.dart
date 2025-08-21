import 'dart:io';

import 'package:dio/dio.dart';
import 'package:echowater/base/constants/constants.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/core/services/marketing_push_service/marketing_push_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../../base/utils/utilities.dart';
import '../../../screens/device_management/app_state.dart';
import '../../../screens/device_management/bloc/device_management_bloc.dart';
import '../../injector/injector.dart';
import '../api_log_service.dart';
import '../crashlytics_service/crashlytics_service.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  Utilities.printObj('Handling a background message: ${message.messageId}');
}

class PushNotificationService {
  PushNotificationService(
      {required CrashlyticsService crashlyticsService,
      required MarketingPushService marketingPushService})
      : _crashlyticsService = crashlyticsService,
        _marketingPushService = marketingPushService {
    init();
  }

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  AndroidNotificationChannel androidNotificationChannel() =>
      const AndroidNotificationChannel(
        'high_importance_channel',
        'high_importance_channel',
        description: 'High Importance Notifications',
        importance: Importance.max,
      );

  final CrashlyticsService _crashlyticsService;
  final MarketingPushService _marketingPushService;

  Future<void> init() async {}

  Future<void> initService() async {
    FlutterError.onError = _crashlyticsService.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      _crashlyticsService.recordError(error, stack, fatal: true);
      return true;
    };
    FirebaseMessaging.instance.onTokenRefresh.listen((event) {
      Injector.instance<DeviceManagementBloc>().add(UpdateDeviceEvent());
    });
    //FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await _setupInteractedMessage();
  }

  Future<void> _setupInteractedMessage() async {
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _onPushNotificationFetched(message, NotificationAppState.onClick);
    });

    FirebaseMessaging.onMessage.listen((message) {
      _onPushNotificationFetched(
          message, NotificationAppState.onForegroundListen);
    });

    await _enableIOSNotifications();
    await _registerNotificationListeners();
  }

  Future<void> _enableIOSNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      sound: true,
      badge: true,
    );
  }

  void showNotification(String message) {
    _flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecond,
      'Echo Water',
      message.stripHtmlTags,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'high_importance_channel',
          priority: Priority.max,
          importance: Importance.max,
        ),
      ),
    );
  }

  Future<void> scheduleNotification(String message, DateTime date) async {
    final currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));
    await _flutterLocalNotificationsPlugin.zonedSchedule(
        DateTime.now().millisecond,
        Constants.appName,
        message.stripHtmlTags,
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'high_importance_channel',
            priority: Priority.max,
            importance: Importance.max,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  Future<void> _registerNotificationListeners() async {
    await _setUpAndroidNotificationSettings();
    const androidSettings =
        AndroidInitializationSettings('@drawable/notification_icon');
    const iOSSettings = DarwinInitializationSettings();

    const initSetttings =
        InitializationSettings(android: androidSettings, iOS: iOSSettings);
    await _flutterLocalNotificationsPlugin.initialize(initSetttings,
        onDidReceiveNotificationResponse: (details) {
      if ((details.payload ?? '') == '') {
        Injector.instance<ApiLogService>().showLog();
      }
    });
  }

  void _onPushNotificationFetched(
      RemoteMessage message, NotificationAppState state) {
    if (Platform.isAndroid) {
      _flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecond,
        message.notification?.title ?? '',
        (message.notification?.body ?? '').stripHtmlTags,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'high_importance_channel',
            priority: Priority.max,
            importance: Importance.max,
          ),
        ),
      );
    }
  }

  Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileName';

    final dio = Dio();
    try {
      final response = await dio.get(
        url,
        options: Options(responseType: ResponseType.bytes),
      );

      // Write the response data to a file
      final file = File(filePath);
      await file.writeAsBytes(response.data);

      return filePath; // Return the path to the saved file
    } catch (e) {
      if (kDebugMode) {
        print('Download failed: $e');
      }
      throw Exception('Failed to download file: $e');
    }
  }

  Future<void> _setUpAndroidNotificationSettings() async {
    final channel = androidNotificationChannel();
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  void resetFCMToken() {
    FirebaseMessaging.instance
        .deleteToken()
        .then((value) => FirebaseMessaging.instance.getToken());
  }

  Future<void> addInitialMessageListener() async {
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _onPushNotificationFetched(
          initialMessage, NotificationAppState.appLaunched);
    }
  }

  Future<String?> getPushToken() async {
    final firebaseMessaging = FirebaseMessaging.instance;

    final _ = await firebaseMessaging.requestPermission();
    final token = await firebaseMessaging.getToken();
    final apnsToken = await firebaseMessaging.getAPNSToken();

    if ((apnsToken ?? '').isNotEmpty && Platform.isIOS) {
      await _marketingPushService.sendTokenToKlaviyo(apnsToken!);
    } else if ((token ?? '').isNotEmpty && Platform.isAndroid) {
      await _marketingPushService.sendTokenToKlaviyo(token!);
    }

    return token;
  }
}
