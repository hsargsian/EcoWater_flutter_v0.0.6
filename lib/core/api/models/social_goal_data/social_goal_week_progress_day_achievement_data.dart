import 'package:echowater/core/domain/entities/social_goal_entity/social_goal_week_progress_day_achievement_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'social_goal_week_progress_day_achievement_data.g.dart';

@JsonSerializable()
class SocialGoalWeekProgressDayAchievementData {
  SocialGoalWeekProgressDayAchievementData(this.userId, this.hasAchieved);

  factory SocialGoalWeekProgressDayAchievementData.fromJson(
          Map<String, dynamic> json) =>
      _$SocialGoalWeekProgressDayAchievementDataFromJson(json);

  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'has_achieved')
  final bool hasAchieved;
  Map<String, dynamic> toJson() =>
      _$SocialGoalWeekProgressDayAchievementDataToJson(this);

  SocialGoalWeekProgressDayAchievementEntity asEntity() =>
      SocialGoalWeekProgressDayAchievementEntity(userId, hasAchieved);
}
