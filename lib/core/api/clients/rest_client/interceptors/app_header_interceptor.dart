import 'package:dio/dio.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

import '../../../../../oc_libraries/device_information_retrieval/device_information_retrieval_service.dart';

class AppHeaderInterceptor extends Interceptor {
  AppHeaderInterceptor(this.deviceInfoService);
  final DeviceInformationRetrievalService deviceInfoService;
  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers.addAll(await _getAppHeader(deviceInfoService));
    handler.next(options);
  }

  static Future<Map<String, String>> _getAppHeader(
      DeviceInformationRetrievalService service) async {
    final deviceInfo = await service.fetchDeviceInformation();
    final currentTimeZone = await FlutterTimezone.getLocalTimezone();
    return {
      'tz': currentTimeZone,
      'deviceid': deviceInfo.name,
      'devicetype': deviceInfo.platform
    };
  }
}
