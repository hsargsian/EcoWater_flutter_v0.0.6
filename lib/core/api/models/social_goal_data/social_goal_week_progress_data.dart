import 'package:echowater/core/api/models/social_goal_data/social_goal_week_progress_day_achievement_data.dart';
import 'package:echowater/core/domain/entities/social_goal_entity/social_goal_week_progress_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'social_goal_week_progress_data.g.dart';

@JsonSerializable()
class SocialGoalWeekProgressData {
  SocialGoalWeekProgressData(this.day, this.achievements);

  factory SocialGoalWeekProgressData.fromJson(Map<String, dynamic> json) =>
      _$SocialGoalWeekProgressDataFromJson(json);

  final String day;
  final List<SocialGoalWeekProgressDayAchievementData> achievements;

  Map<String, dynamic> toJson() => _$SocialGoalWeekProgressDataToJson(this);

  SocialGoalWeekProgressEntity asEntity() => SocialGoalWeekProgressEntity(
      day, achievements.map((item) => item.asEntity()).toList());
}
