import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/walk_through_progress_entity/walk_through_progress_entity.dart';

part 'walk_through_progress_data.g.dart';

@JsonSerializable()
class WalkThroughProgressData {
  WalkThroughProgressData(
      this.hasSeenLearningWalkthrough,
      this.hasSeenDashboardWalkthrough,
      this.hasSeenGoalWalkthrough,
      this.hasSeenHomescreenWalkthrough);

  factory WalkThroughProgressData.fromJson(Map<String, dynamic> json) =>
      _$WalkThroughProgressDataFromJson(json);

  @JsonKey(name: 'has_seen_learning_walkthrough')
  final bool hasSeenLearningWalkthrough;
  @JsonKey(name: 'has_seen_dashboard_walkthrough')
  final bool hasSeenDashboardWalkthrough;
  @JsonKey(name: 'has_seen_goal_walkthrough')
  final bool hasSeenGoalWalkthrough;
  @JsonKey(name: 'has_seen_homescreen_walkthrough')
  final bool hasSeenHomescreenWalkthrough;

  Map<String, dynamic> toJson() => _$WalkThroughProgressDataToJson(this);

  WalkThroughProgressEntity asEntity() => WalkThroughProgressEntity(
      hasSeenHomescreenWalkthrough,
      hasSeenGoalWalkthrough,
      hasSeenLearningWalkthrough,
      hasSeenDashboardWalkthrough);
}
