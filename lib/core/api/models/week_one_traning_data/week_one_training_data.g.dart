// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'week_one_training_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeekOneTraningData _$WeekOneTraningDataFromJson(Map<String, dynamic> json) =>
    WeekOneTraningData(
      json['id'] as int,
      json['day'] as int,
      json['tag_title'] as String,
      json['image'] as String?,
      json['title'] as String?,
      json['description'] as String?,
      (json['check_items'] as List<dynamic>?)?.map((e) => e as String).toList(),
      json['sub_description'] as String?,
      (json['quotes'] as List<dynamic>?)
          ?.map((e) =>
              WeekOneTraningQuoteData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WeekOneTraningDataToJson(WeekOneTraningData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'day': instance.day,
      'tag_title': instance.tagTitle,
      'image': instance.image,
      'title': instance.title,
      'description': instance.description,
      'check_items': instance.checkItems,
      'sub_description': instance.subDesctiption,
      'quotes': instance.quotes,
    };
