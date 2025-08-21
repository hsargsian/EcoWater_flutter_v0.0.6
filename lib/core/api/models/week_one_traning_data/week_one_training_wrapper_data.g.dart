// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'week_one_training_wrapper_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeekOneTraningWrapperData _$WeekOneTraningWrapperDataFromJson(
        Map<String, dynamic> json) =>
    WeekOneTraningWrapperData(
      (json['results'] as List<dynamic>)
          .map((e) => WeekOneTraningData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WeekOneTraningWrapperDataToJson(
        WeekOneTraningWrapperData instance) =>
    <String, dynamic>{
      'results': instance.results,
    };
