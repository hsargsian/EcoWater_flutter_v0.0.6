// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'week_one_training_stat_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeekOneTrainingStatEntity _$WeekOneTrainingStatEntityFromJson(
        Map<String, dynamic> json) =>
    WeekOneTrainingStatEntity(
      json['weekOneTrainingDayProgress'] as int,
      json['weekOneTrainingStartDay'] as String?,
      json['weekOneLastTrainingDay'] as String?,
      json['hasClosedWeekTraining'] as bool,
    );

Map<String, dynamic> _$WeekOneTrainingStatEntityToJson(
        WeekOneTrainingStatEntity instance) =>
    <String, dynamic>{
      'weekOneTrainingDayProgress': instance.weekOneTrainingDayProgress,
      'weekOneTrainingStartDay': instance.weekOneTrainingStartDay,
      'weekOneLastTrainingDay': instance.weekOneLastTrainingDay,
      'hasClosedWeekTraining': instance.hasClosedWeekTraining,
    };
