import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:echowater/core/api/models/flask_data/flask_data.dart';
import 'package:echowater/core/api/models/flask_firmware_version_data/flask_firmware_version_data.dart';
import 'package:echowater/core/api/models/flask_wrapper_data/flask_wrapper_data.dart';
import 'package:echowater/core/api/models/led_light_color_wrapper_data/led_light_color_wrapper_data.dart';

import '../../../api/clients/rest_client/authorized_api_client/authorized_api_client.dart';
import '../../../api/exceptions/exception_handler.dart';
import '../../../api/models/device_ personalization_settings/device_personalization_settings_data.dart';
import '../../../api/models/empty_success_response/api_success_message_response.dart';
import '../../../api/models/empty_success_response/empty_success_response.dart';

abstract class FlaskRemoteDataSource {
  Future<FlaskWrapperData> fetchMyFlasks(
      {required int offset, required int perPage});

  Future<EmptySuccessResponse> deleteMyFlask({required String flaskId});

  Future<FlaskData> addNewFlask(
      {required String flaskId, required String name});

  Future<FlaskData> toggleFlaskPair(
      {required String flaskId, required bool isPaired});

  Future<List<LedLightColorWrapperData>> fetchLedColors();

  Future<FlaskData> updateFlask(
      {required String flaskId,
      required String name,
      required bool ledlightMode,
      required int colorId,
      required double volume,
      required int wakeUpFromSleepTime,
      String? bleVersion,
      String? mcuVersion});

  Future<ApiSuccessMessageResponse> cleanFlask({required String flaskId});

  Future<ApiSuccessMessageResponse> startFlaskCycle(
      {required String flaskId, required double? ppmGenerated});

  Future<FlaskFirmwareVersionData> fetchFlaskVersion(
      {required String flaskId,
      required String? bleVersion,
      required double? mcuVersion});

  Future<DevicePersonalizationSettingsData> fetchFlaskPersonalizationOptions();

  Future<bool> updateFirmwareLog(
      {required String flaskSerialId, required String updateType});
  Future<bool> uploadBLELog(
      {required String flaskSerialId, required List<Map<String, dynamic>> log});
}

class FlaskRemoteDataSourceImpl extends FlaskRemoteDataSource {
  FlaskRemoteDataSourceImpl({required AuthorizedApiClient authorizedApiClient})
      : _authorizedApiClient = authorizedApiClient;

  final AuthorizedApiClient _authorizedApiClient;

  CancelToken _fetchMyFlasksCancelToken = CancelToken();
  CancelToken _addMyFlaskCancelToken = CancelToken();
  CancelToken _updateMyFlaskCancelToken = CancelToken();

  @override
  Future<EmptySuccessResponse> deleteMyFlask({required String flaskId}) async {
    try {
      await _authorizedApiClient.unpairFlask(flaskId);
      return Future.value(EmptySuccessResponse());
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<FlaskWrapperData> fetchMyFlasks(
      {required int offset, required int perPage}) {
    try {
      _fetchMyFlasksCancelToken.cancel();
      _fetchMyFlasksCancelToken = CancelToken();

      return _authorizedApiClient.fetchFlasks(
          offset, perPage, _fetchMyFlasksCancelToken);
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<FlaskData> addNewFlask(
      {required String flaskId, required String name}) {
    try {
      _addMyFlaskCancelToken.cancel();
      _addMyFlaskCancelToken = CancelToken();
      return _authorizedApiClient.addNewFlask(
          flaskId, name, _addMyFlaskCancelToken);
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<FlaskData> updateFlask(
      {required String flaskId,
      required String name,
      required bool ledlightMode,
      required int colorId,
      required double volume,
      required int wakeUpFromSleepTime,
      String? bleVersion,
      String? mcuVersion}) {
    try {
      _updateMyFlaskCancelToken.cancel();
      _updateMyFlaskCancelToken = CancelToken();

      return _authorizedApiClient.updateFlask(
          flaskId,
          name,
          colorId,
          ledlightMode,
          volume,
          wakeUpFromSleepTime,
          bleVersion,
          mcuVersion,
          _updateMyFlaskCancelToken);
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<FlaskData> toggleFlaskPair(
      {required String flaskId, required bool isPaired}) async {
    try {
      return _authorizedApiClient.toggleDevicePair(flaskId, isPaired);
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<List<LedLightColorWrapperData>> fetchLedColors() async {
    try {
      return (await _authorizedApiClient.fetchLedColors()).results;
    } catch (e, st) {
      log('error $st');
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<ApiSuccessMessageResponse> cleanFlask(
      {required String flaskId}) async {
    try {
      return _authorizedApiClient.cleanFlask(flaskId);
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<ApiSuccessMessageResponse> startFlaskCycle(
      {required String flaskId, required double? ppmGenerated}) async {
    try {
      return _authorizedApiClient.startFlaskCycle(flaskId, ppmGenerated);
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<FlaskFirmwareVersionData> fetchFlaskVersion(
      {required String flaskId,
      required String? bleVersion,
      required double? mcuVersion}) async {
    try {
      return _authorizedApiClient.fetchFlaskVersion(
          flaskId, mcuVersion, bleVersion);
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<DevicePersonalizationSettingsData>
      fetchFlaskPersonalizationOptions() async {
    try {
      return _authorizedApiClient.fetchFlaskPersonalizationOptions();
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<bool> updateFirmwareLog(
      {required String flaskSerialId, required String updateType}) async {
    //TODO: ASHWIN return true directly
    //return true;
    try {
      final _ = await _authorizedApiClient.updateFirmwareLog(
          flaskSerialId, updateType);
      return true;
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<bool> uploadBLELog(
      {required String flaskSerialId,
      required List<Map<String, dynamic>> log}) async {
    try {
      final _ = await _authorizedApiClient.uploadBLELog(flaskSerialId, log);
      return true;
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }
}
