// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customize_protocol_active_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomizeProtocolActiveRequestModel
    _$CustomizeProtocolActiveRequestModelFromJson(Map<String, dynamic> json) =>
        CustomizeProtocolActiveRequestModel(
          protocolType: json['protocol_type'] as String,
          protocolId: json['protocol_id'] as int,
          updateGoals: json['update_goals'] as bool,
          activate: json['activate'] as bool,
        );

Map<String, dynamic> _$CustomizeProtocolActiveRequestModelToJson(
        CustomizeProtocolActiveRequestModel instance) =>
    <String, dynamic>{
      'protocol_type': instance.protocolType,
      'protocol_id': instance.protocolId,
      'update_goals': instance.updateGoals,
      'activate': instance.activate,
    };
