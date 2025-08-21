// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flask_firmware_version_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FlaskFirmwareVersionEntity _$FlaskFirmwareVersionEntityFromJson(
        Map<String, dynamic> json) =>
    FlaskFirmwareVersionEntity(
      json['currentVersion'] as String?,
      json['blePath'] as String?,
      json['mcuPath'] as String?,
      (json['imagePaths'] as List<dynamic>?)?.map((e) => e as String).toList(),
      json['mandatoryVersionCheck'] as bool,
    );

Map<String, dynamic> _$FlaskFirmwareVersionEntityToJson(
        FlaskFirmwareVersionEntity instance) =>
    <String, dynamic>{
      'currentVersion': instance.currentVersion,
      'blePath': instance.blePath,
      'mcuPath': instance.mcuPath,
      'imagePaths': instance.imagePaths,
      'mandatoryVersionCheck': instance.mandatoryVersionCheck,
    };
