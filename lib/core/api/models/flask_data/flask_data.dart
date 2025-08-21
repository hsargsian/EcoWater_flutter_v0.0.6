import 'package:echowater/base/constants/constants.dart';
import 'package:echowater/core/api/models/led_light_color_wrapper_data/led_light_color_data.dart';
import 'package:echowater/core/domain/entities/flask_entity/flask_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'flask_data.g.dart';

@JsonSerializable()
class FlaskData {
  FlaskData(
      this.id,
      this.name,
      this.isPaired,
      this.selectedColor,
      this.isLightMode,
      this.serialId,
      this.flaskVolume,
      this.wakeUpFromSleepTime,
      this.bleVersion,
      this.mcuVersion);
  FlaskData.dummy()
      : id = '123123',
        name = "Ashwin's Flask",
        isPaired = false,
        selectedColor = LedLightColorData(
          1,
          true,
          'warm',
          1,
          [],
        ),
        isLightMode = false,
        serialId = '1213',
        flaskVolume = Constants.defaultFlaskVolume.toDouble(),
        wakeUpFromSleepTime = Constants.defaultWakeFromSleepTime,
        bleVersion = null,
        mcuVersion = null;

  factory FlaskData.fromJson(Map<String, dynamic> json) =>
      _$FlaskDataFromJson(json);

  final String id;
  final String name;
  final bool? isPaired;
  @JsonKey(
      name: 'led_color',
      fromJson: LedLightColorDataConverter.fromJson,
      toJson: LedLightColorDataConverter.toJson)
  final LedLightColorData? selectedColor;
  @JsonKey(name: 'led_light_mode')
  final bool isLightMode;
  @JsonKey(name: 'serial_id')
  final String serialId;
  @JsonKey(name: 'volume')
  final double? flaskVolume;
  @JsonKey(name: 'sleep_timer')
  final int? wakeUpFromSleepTime;
  @JsonKey(name: 'ble_version')
  final String? bleVersion;
  @JsonKey(name: 'mcu_version')
  final String? mcuVersion;

  Map<String, dynamic> toJson() => _$FlaskDataToJson(this);

  FlaskEntity asEntity() => FlaskEntity(
      id,
      name,
      isPaired ?? true,
      selectedColor?.asEntity(),
      isLightMode,
      serialId,
      flaskVolume ?? Constants.defaultFlaskVolume.toDouble(),
      wakeUpFromSleepTime ?? Constants.defaultWakeFromSleepTime,
      bleVersion,
      mcuVersion);
}

class LedLightColorDataConverter {
  LedLightColorDataConverter();

  static LedLightColorData? fromJson(final dynamic json) {
    if (json is Map<String, dynamic>) {
      return LedLightColorData.fromJson(json);
    } else {
      return null;
    }
  }

  static dynamic toJson(final LedLightColorData? selectedColor) =>
      selectedColor?.toJson();
}
