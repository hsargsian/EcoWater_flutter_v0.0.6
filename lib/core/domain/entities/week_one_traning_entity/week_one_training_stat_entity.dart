import 'package:json_annotation/json_annotation.dart';

import '../../domain_models/week_one_training_stat_domain.dart';

part 'week_one_training_stat_entity.g.dart';

@JsonSerializable()
class WeekOneTrainingStatEntity {
  WeekOneTrainingStatEntity(
      this.weekOneTrainingDayProgress,
      this.weekOneTrainingStartDay,
      this.weekOneLastTrainingDay,
      this.hasClosedWeekTraining);

  factory WeekOneTrainingStatEntity.fromJson(Map<String, dynamic> json) =>
      _$WeekOneTrainingStatEntityFromJson(json);

  int weekOneTrainingDayProgress;
  String? weekOneTrainingStartDay;
  final String? weekOneLastTrainingDay;
  bool hasClosedWeekTraining;

  Map<String, dynamic> toJson() => _$WeekOneTrainingStatEntityToJson(this);
  WeekOneTraningStatDomain toDomain() => WeekOneTraningStatDomain(this);
}
