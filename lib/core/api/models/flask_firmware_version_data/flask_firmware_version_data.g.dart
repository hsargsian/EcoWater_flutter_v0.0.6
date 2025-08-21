// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flask_firmware_version_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FlaskFirmwareVersionData _$FlaskFirmwareVersionDataFromJson(
        Map<String, dynamic> json) =>
    FlaskFirmwareVersionData(
      json['current_version'] as String?,
      json['ble_path'] as String?,
      json['mcu_path'] as String?,
      (json['image_paths'] as List<dynamic>?)?.map((e) => e as String).toList(),
      json['mandatory_version_check'] as bool?,
    );

Map<String, dynamic> _$FlaskFirmwareVersionDataToJson(
        FlaskFirmwareVersionData instance) =>
    <String, dynamic>{
      'current_version': instance.currentVerion,
      'ble_path': instance.blePath,
      'mcu_path': instance.mcuPath,
      'image_paths': instance.imagePaths,
      'mandatory_version_check': instance.mandatoryVersionCheck,
    };
