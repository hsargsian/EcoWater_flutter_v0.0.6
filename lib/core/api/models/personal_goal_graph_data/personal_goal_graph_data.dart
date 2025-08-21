import 'package:echowater/core/domain/entities/personal_goal_graph_entity/personal_goal_graph_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'personal_goal_graph_data.g.dart';

@JsonSerializable()
class PersonalGoalGraphData {
  PersonalGoalGraphData(
    this.date,
    this.goalAmount,
    this.progress,
  );

  factory PersonalGoalGraphData.fromJson(Map<String, dynamic> json) => _$PersonalGoalGraphDataFromJson(json);

  final String date;
  @JsonKey(name: 'goal_amount')
  final num goalAmount;
  final num progress;

  Map<String, dynamic> toJson() => _$PersonalGoalGraphDataToJson(this);

  PersonalGoalGraphEntity asEntity() => PersonalGoalGraphEntity(date, goalAmount, progress);
}
