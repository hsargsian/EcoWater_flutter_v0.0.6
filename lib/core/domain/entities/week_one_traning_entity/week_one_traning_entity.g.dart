// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'week_one_traning_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeekOneTraningEntity _$WeekOneTraningEntityFromJson(
        Map<String, dynamic> json) =>
    WeekOneTraningEntity(
      json['day'] as int,
      json['tagTitle'] as String,
      json['image'] as String?,
      json['title'] as String?,
      json['description'] as String?,
      (json['checkItems'] as List<dynamic>?)?.map((e) => e as String).toList(),
      json['subDesctiption'] as String?,
      (json['quotes'] as List<dynamic>?)
          ?.map((e) =>
              WeekOneTraningQuoteEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WeekOneTraningEntityToJson(
        WeekOneTraningEntity instance) =>
    <String, dynamic>{
      'day': instance.day,
      'tagTitle': instance.tagTitle,
      'image': instance.image,
      'title': instance.title,
      'description': instance.description,
      'checkItems': instance.checkItems,
      'subDesctiption': instance.subDesctiption,
      'quotes': instance.quotes,
    };
