// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flask_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FlaskData _$FlaskDataFromJson(Map<String, dynamic> json) => FlaskData(
      json['id'] as String,
      json['name'] as String,
      json['isPaired'] as bool?,
      LedLightColorDataConverter.fromJson(json['led_color']),
      json['led_light_mode'] as bool,
      json['serial_id'] as String,
      (json['volume'] as num?)?.toDouble(),
      json['sleep_timer'] as int?,
      json['ble_version'] as String?,
      json['mcu_version'] as String?,
    );

Map<String, dynamic> _$FlaskDataToJson(FlaskData instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'isPaired': instance.isPaired,
      'led_color': LedLightColorDataConverter.toJson(instance.selectedColor),
      'led_light_mode': instance.isLightMode,
      'serial_id': instance.serialId,
      'volume': instance.flaskVolume,
      'sleep_timer': instance.wakeUpFromSleepTime,
      'ble_version': instance.bleVersion,
      'mcu_version': instance.mcuVersion,
    };
