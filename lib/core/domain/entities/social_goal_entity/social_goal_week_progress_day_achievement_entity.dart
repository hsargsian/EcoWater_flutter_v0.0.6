import 'package:echowater/core/domain/domain_models/social_goal_week_progress_day_achievement_domain.dart';
import 'package:json_annotation/json_annotation.dart';

part 'social_goal_week_progress_day_achievement_entity.g.dart';

@JsonSerializable()
class SocialGoalWeekProgressDayAchievementEntity {
  SocialGoalWeekProgressDayAchievementEntity(this.userId, this.hasAchieved);

  factory SocialGoalWeekProgressDayAchievementEntity.fromJson(
          Map<String, dynamic> json) =>
      _$SocialGoalWeekProgressDayAchievementEntityFromJson(json);

  final String userId;
  final bool hasAchieved;

  Map<String, dynamic> toJson() =>
      _$SocialGoalWeekProgressDayAchievementEntityToJson(this);
  SocialGoalWeekProgressDayAchievementDomain toDomain() =>
      SocialGoalWeekProgressDayAchievementDomain(this);

  static List<SocialGoalWeekProgressDayAchievementEntity> getDummy() {
    return List.generate(2, (index) {
      return SocialGoalWeekProgressDayAchievementEntity(index.toString(), true);
    });
  }
}
