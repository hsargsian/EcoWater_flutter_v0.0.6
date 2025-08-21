import 'package:device_info_plus/device_info_plus.dart';
import 'package:echowater/core/services/api_cache_retry_service/api_cache_retry_service.dart';
import 'package:echowater/core/services/firmware_update_log_report_service.dart';
import 'package:echowater/core/services/marketing_push_service/klaviyo_manager.dart';
import 'package:echowater/core/services/marketing_push_service/marketing_push_service.dart';
import 'package:echowater/oc_libraries/ble_service/flask_manager.dart';
import 'package:echowater/oc_libraries/health_kit_service/health_service.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../oc_libraries/device_information_retrieval/device_information_retrieval_service.dart';
import '../../oc_libraries/device_information_retrieval/device_information_retrieval_service_impl.dart';
import '../services/api_log_service.dart';
import '../services/crashlytics_service/crashlytics_service.dart';
import '../services/crashlytics_service/firebase_crashlytics_service.dart';
import '../services/local_storage_service/local_storage_service.dart';
import '../services/local_storage_service/secured_storage_service.dart';
import '../services/log_service/debug_log_service.dart';
import '../services/log_service/log_service.dart';
import '../services/push_notification_service/push_notification_service.dart';
import '../services/share_service.dart';
import 'injector.dart';

class ServiceModule {
  ServiceModule._();

  static Future<void> init() async {
    final healthService = HealthService()..initalizeService();
    final injector = Injector.instance;
    injector
      ..registerSingleton<ApiLogService>(ApiLogService())
      ..registerSingletonAsync<DeviceInformationRetrievalService>(() async {
        return DeviceInformationRetrievalServiceImpl.init();
      })
      ..registerSingleton<CrashlyticsService>(FirebaseCrashlyticsService())
      ..registerSingleton<MarketingPushService>(KlaviyoMarketingPushService())
      ..registerSingletonAsync<PushNotificationService>(() async {
        final pushNotificationService = PushNotificationService(
            crashlyticsService: injector(), marketingPushService: injector());
        return pushNotificationService;
      })
      ..registerFactory<LogService>(DebugLogService.new)
      ..registerSingletonAsync<LocalStorageService>(() async {
        final LocalStorageService service = SecuredStorageService();
        return service;
      })
      ..registerSingleton<ShareService>(ShareService())
      ..registerSingleton<FirmwareUpdateLogReportService>(
          FirmwareUpdateLogReportService())
      ..registerSingleton<HealthService>(healthService)
      ..registerSingleton<FlaskManager>(FlaskManager())
      ..registerSingleton<ApiCacheRetryService>(ApiCacheRetryService());
  }
}
