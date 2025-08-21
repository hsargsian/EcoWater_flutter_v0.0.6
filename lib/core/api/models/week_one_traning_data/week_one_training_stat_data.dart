import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/week_one_traning_entity/week_one_training_stat_entity.dart';

part 'week_one_training_stat_data.g.dart';

@JsonSerializable()
class WeekOneTraningStatData {
  WeekOneTraningStatData(
      this.weekOneTrainingDayProgress,
      this.weekOneTrainingStartDay,
      this.lastTrainingDay,
      this.hasClosedWeekTraining);

  factory WeekOneTraningStatData.fromJson(Map<String, dynamic> json) =>
      _$WeekOneTraningStatDataFromJson(json);

  @JsonKey(name: 'week_one_training_day_progress')
  final int weekOneTrainingDayProgress;
  @JsonKey(name: 'week_one_training_start_day')
  final String? weekOneTrainingStartDay;
  @JsonKey(name: 'last_training_day')
  final String? lastTrainingDay;
  @JsonKey(name: 'has_closed_week_training')
  final bool hasClosedWeekTraining;

  Map<String, dynamic> toJson() => _$WeekOneTraningStatDataToJson(this);
  WeekOneTrainingStatEntity asEntity() => WeekOneTrainingStatEntity(
      weekOneTrainingDayProgress,
      weekOneTrainingStartDay,
      lastTrainingDay,
      hasClosedWeekTraining);
}
