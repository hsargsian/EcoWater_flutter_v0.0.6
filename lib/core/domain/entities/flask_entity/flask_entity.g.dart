// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flask_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FlaskEntity _$FlaskEntityFromJson(Map<String, dynamic> json) => FlaskEntity(
      json['id'] as String,
      json['name'] as String,
      json['isPaired'] as bool,
      json['selectedColor'] == null
          ? null
          : LedLightColorEntity.fromJson(
              json['selectedColor'] as Map<String, dynamic>),
      json['isLightMode'] as bool,
      json['serialId'] as String,
      (json['flaskVolume'] as num).toDouble(),
      json['wakeUpFromSleepTime'] as int,
      json['bleVersion'] as String?,
      json['mcuVersion'] as String?,
    );

Map<String, dynamic> _$FlaskEntityToJson(FlaskEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'isPaired': instance.isPaired,
      'selectedColor': instance.selectedColor,
      'isLightMode': instance.isLightMode,
      'serialId': instance.serialId,
      'flaskVolume': instance.flaskVolume,
      'wakeUpFromSleepTime': instance.wakeUpFromSleepTime,
      'bleVersion': instance.bleVersion,
      'mcuVersion': instance.mcuVersion,
    };
