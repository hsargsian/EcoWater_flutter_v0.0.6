import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:echowater/core/services/marketing_push_service/marketing_push_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:klaviyo_flutter/klaviyo_flutter.dart';
import 'package:timezone/data/latest_all.dart' as tz;

import 'config/http_overrides.dart';
import 'core/injector/injector.dart';
import 'firebase_options.dart';
import 'flavor_config.dart';
import 'main_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  tz.initializeTimeZones();
  await initializeDateFormatting();
  await configureBLEData();
  HttpOverrides.global = MyHttpOverrides();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //await FirebaseRemoteLocalizationService().initService();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await Injector.init();
  await Injector.instance.allReady();
  await EasyLocalization.ensureInitialized();
  await Injector.instance<MarketingPushService>().initializeWithKey(key: FlavorConfig.klaviyoApiKey());
  runApp(
    EasyLocalization(
        supportedLocales: const [Locale('en', 'US')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en', 'US'),
        child: const EchoWaterApp()),
  );
}

Future<void> configureBLEData() async {
  const pref = FlutterSecureStorage();
  final configuredBLE = await pref.read(key: 'configuredBLE') ?? '0';
  if (configuredBLE == '0') {
    await pref.write(key: 'serviceUUId', value: '65010001-1D0F-47D7-B149-C2FDF0006916');
    await pref.write(key: 'txCharUUid', value: '65010002-1D0F-47D7-B149-C2FDF0006916');
    await pref.write(key: 'rxCharUUid', value: '65010003-1D0F-47D7-B149-C2FDF0006916');
    await pref.write(key: 'configuredBLE', value: '1');
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (Klaviyo.instance.isKlaviyoPush(message.data)) {
    await Klaviyo.instance.handlePush(message.data);
  }
}
