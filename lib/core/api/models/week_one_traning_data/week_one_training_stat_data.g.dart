// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'week_one_training_stat_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeekOneTraningStatData _$WeekOneTraningStatDataFromJson(
        Map<String, dynamic> json) =>
    WeekOneTraningStatData(
      json['week_one_training_day_progress'] as int,
      json['week_one_training_start_day'] as String?,
      json['last_training_day'] as String?,
      json['has_closed_week_training'] as bool,
    );

Map<String, dynamic> _$WeekOneTraningStatDataToJson(
        WeekOneTraningStatData instance) =>
    <String, dynamic>{
      'week_one_training_day_progress': instance.weekOneTrainingDayProgress,
      'week_one_training_start_day': instance.weekOneTrainingStartDay,
      'last_training_day': instance.lastTrainingDay,
      'has_closed_week_training': instance.hasClosedWeekTraining,
    };
