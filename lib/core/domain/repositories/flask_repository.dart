import 'package:echowater/core/domain/entities/api_success_message_response_entity/api_success_message_response_entity.dart';
import 'package:echowater/core/domain/entities/flask_entity/flask_entity.dart';
import 'package:echowater/core/domain/entities/flask_entity/flask_wrapper_entity.dart';
import 'package:echowater/core/domain/entities/flask_firmware_version_entity/flask_firmware_version_entity.dart';
import 'package:echowater/core/domain/entities/led_light_color_entity/led_light_color_wrapper_entity.dart';

import '../../api/resource/resource.dart';
import '../entities/DevicePersonalizationSettingsEntity/device_personalization_settings_entity.dart';

abstract class FlaskRepository {
  Future<Result<FlaskWrapperEntity>> fetchMyFlasks(
      {required int offset, required int perPage});

  Future<Result<FlaskFirmwareVersionEntity>> fetchFlaskVersion(
      {required String flaskId,
      required String? bleVersion,
      required double? mcuVersion});

  Future<Result<List<LedLightColorWrapperEntity>>> fetchLedColors();

  Future<Result<bool>> deleteFlask({required String flaskId});

  Future<Result<FlaskEntity>> toggleFlaskPair(
      {required String flaskId, required bool isPaired});

  Future<Result<FlaskEntity>> addNewFlask(
      {required String identifier, required String name});

  Future<Result<ApiSuccessMessageResponseEntity>> cleanFlask(
      {required String id});

  Future<Result<ApiSuccessMessageResponseEntity>> startFlaskCycle(
      {required String id, required double? ppmGenerated});

  Future<Result<FlaskEntity>> updateFlask(
      {required String bleDeviceId,
      required bool ledLightMode,
      required String name,
      required int colorId,
      required double volume,
      required int wakeUpFromSleepTime,
      String? bleVersion,
      String? mcuVersion});

  Future<Result<DevicePersonalizationSettingsEntity>>
      fetchFlaskPersonalizationOptions();
  Future<Result<bool>> updateFirmwareLog(
      {required String flaskSerialId, required String updateType});
  Future<Result<bool>> uploadBLELog(
      {required String flaskSerialId, required List<Map<String, dynamic>> log});
}
