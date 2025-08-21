import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:echowater/core/data/data_sources/flask_data_sources/flask_local_data_source.dart';
import 'package:echowater/core/data/data_sources/flask_data_sources/flask_remote_data_source.dart';
import 'package:echowater/core/domain/entities/DevicePersonalizationSettingsEntity/device_personalization_settings_entity.dart';
import 'package:echowater/core/domain/entities/api_success_message_response_entity/api_success_message_response_entity.dart';
import 'package:echowater/core/domain/entities/flask_entity/flask_entity.dart';
import 'package:echowater/core/domain/entities/flask_firmware_version_entity/flask_firmware_version_entity.dart';
import 'package:echowater/core/domain/entities/led_light_color_entity/led_light_color_wrapper_entity.dart';
import 'package:echowater/core/domain/repositories/flask_repository.dart';

import '../../api/exceptions/custom_exception.dart';
import '../../api/resource/resource.dart';
import '../../domain/entities/flask_entity/flask_wrapper_entity.dart';
import '../../services/api_cache_retry_service/api_cache_retry_service.dart';
import '../../services/marketing_push_service/marketing_push_service.dart';

class FlaskRepositoryImpl implements FlaskRepository {
  FlaskRepositoryImpl(
      {required FlaskRemoteDataSource remoteDataSource,
      required FlaskLocalDataSource localDataSource,
      required MarketingPushService marketingPushService,
      required ApiCacheRetryService cacheAndRetryService})
      : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _marketingPushService = marketingPushService,
        _cacheAndRetryService = cacheAndRetryService;

  final FlaskRemoteDataSource _remoteDataSource;
  final FlaskLocalDataSource _localDataSource;
  final MarketingPushService _marketingPushService;
  final ApiCacheRetryService _cacheAndRetryService;

  @override
  Future<Result<FlaskWrapperEntity>> fetchMyFlasks(
      {required int offset, required int perPage}) async {
    try {
      final appBleBleResponse = await _remoteDataSource.fetchMyFlasks(
          offset: offset, perPage: perPage);
      _marketingPushService
          .addProperties({'flasks': appBleBleResponse.flasks.length});
      return Result.success(appBleBleResponse.asEntity());
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<bool>> deleteFlask({required String flaskId}) async {
    try {
      await _remoteDataSource.deleteMyFlask(flaskId: flaskId);

      return const Result.success(true);
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<FlaskEntity>> addNewFlask(
      {required String identifier, required String name}) async {
    try {
      final flask =
          await _remoteDataSource.addNewFlask(flaskId: identifier, name: name);

      return Result.success(flask.asEntity());
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<FlaskEntity>> updateFlask(
      {required String bleDeviceId,
      required bool ledLightMode,
      required String name,
      required int colorId,
      required double volume,
      required int wakeUpFromSleepTime,
      String? bleVersion,
      String? mcuVersion}) async {
    try {
      final updateResponse = await _remoteDataSource.updateFlask(
          flaskId: bleDeviceId,
          ledlightMode: ledLightMode,
          name: name,
          colorId: colorId,
          volume: volume,
          wakeUpFromSleepTime: wakeUpFromSleepTime,
          bleVersion: bleVersion,
          mcuVersion: mcuVersion);

      return Result.success(updateResponse.asEntity());
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<FlaskEntity>> toggleFlaskPair(
      {required String flaskId, required bool isPaired}) async {
    try {
      final flask = await _remoteDataSource.toggleFlaskPair(
          flaskId: flaskId, isPaired: isPaired);

      return Result.success(flask.asEntity());
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<List<LedLightColorWrapperEntity>>> fetchLedColors() async {
    try {
      final flaskColors = await _remoteDataSource.fetchLedColors();

      return Result.success(
          flaskColors.map((item) => item.asEntity()).toList());
    } on CustomException catch (e, st) {
      log('error$st');
      return Result.error(e);
    }
  }

  @override
  Future<Result<ApiSuccessMessageResponseEntity>> cleanFlask(
      {required String id}) async {
    try {
      final response = await _remoteDataSource.cleanFlask(flaskId: id);

      return Result.success(response.asEntity());
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<ApiSuccessMessageResponseEntity>> startFlaskCycle(
      {required String id, required double? ppmGenerated}) async {
    try {
      final response = await _remoteDataSource.startFlaskCycle(
          flaskId: id, ppmGenerated: ppmGenerated);

      return Result.success(response.asEntity());
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<FlaskFirmwareVersionEntity>> fetchFlaskVersion(
      {required String flaskId,
      required String? bleVersion,
      required double? mcuVersion}) async {
    try {
      final response = await _remoteDataSource.fetchFlaskVersion(
          flaskId: flaskId, bleVersion: bleVersion, mcuVersion: mcuVersion);

      return Result.success(response.asEntity());
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<DevicePersonalizationSettingsEntity>>
      fetchFlaskPersonalizationOptions() async {
    try {
      final response =
          await _remoteDataSource.fetchFlaskPersonalizationOptions();
      return Result.success(response.asEntity());
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<bool>> updateFirmwareLog(
      {required String flaskSerialId, required String updateType}) async {
    try {
      final response = await _remoteDataSource.updateFirmwareLog(
          flaskSerialId: flaskSerialId, updateType: updateType);
      return Result.success(response);
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<bool>> uploadBLELog(
      {required String flaskSerialId,
      required List<Map<String, dynamic>> log}) async {
    try {
      final response = await _remoteDataSource.uploadBLELog(
          flaskSerialId: flaskSerialId, log: log);
      return Result.success(response);
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }
}
