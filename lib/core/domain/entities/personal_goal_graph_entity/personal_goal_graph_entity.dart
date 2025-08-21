import 'package:json_annotation/json_annotation.dart';

import '../../domain_models/personal_goal_graph_domain.dart';

part 'personal_goal_graph_entity.g.dart';

@JsonSerializable()
class PersonalGoalGraphEntity {
  PersonalGoalGraphEntity(this.date, this.goalAmount, this.progress);

  factory PersonalGoalGraphEntity.fromJson(Map<String, dynamic> json) => _$PersonalGoalGraphEntityFromJson(json);

  String date;
  num goalAmount;
  num progress;

  Map<String, dynamic> toJson() => _$PersonalGoalGraphEntityToJson(this);

  PersonalGoalGraphDomain toDomain() => PersonalGoalGraphDomain(this);
}
