// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customize_protocol_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomizeProtocolModel _$CustomizeProtocolModelFromJson(
        Map<String, dynamic> json) =>
    CustomizeProtocolModel(
      id: json['id'] as int,
      title: json['title'] as String,
      category: json['category'] as String,
      image: json['image'] as String?,
      isActive: json['is_active'] as bool,
      isTemplate: json['is_template'] as bool?,
      routines: (json['routines'] as List<dynamic>)
          .map((e) => Routine.fromJson(e as Map<String, dynamic>))
          .toList(),
      protocol: json['protocol'] as int?,
    );

Map<String, dynamic> _$CustomizeProtocolModelToJson(
        CustomizeProtocolModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'category': instance.category,
      'image': instance.image,
      'is_active': instance.isActive,
      'is_template': instance.isTemplate,
      'routines': instance.routines,
      'protocol': instance.protocol,
    };

Routine _$RoutineFromJson(Map<String, dynamic> json) => Routine(
      day: json['day'] as String,
      activeDay: json['active_day'] as bool,
      items: (json['items'] as List<dynamic>)
          .map((e) => RoutineItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      id: json['id'] as int?,
    );

Map<String, dynamic> _$RoutineToJson(Routine instance) => <String, dynamic>{
      'id': instance.id,
      'day': instance.day,
      'active_day': instance.activeDay,
      'items': instance.items,
    };

RoutineItem _$RoutineItemFromJson(Map<String, dynamic> json) => RoutineItem(
      title: json['title'] as String,
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      id: json['id'] as int?,
    );

Map<String, dynamic> _$RoutineItemToJson(RoutineItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
    };
