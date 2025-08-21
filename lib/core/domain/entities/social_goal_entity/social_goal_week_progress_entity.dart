import 'package:json_annotation/json_annotation.dart';

import '../../domain_models/social_goal_week_progress_domain.dart';
import 'social_goal_week_progress_day_achievement_entity.dart';

part 'social_goal_week_progress_entity.g.dart';

@JsonSerializable()
class SocialGoalWeekProgressEntity {
  SocialGoalWeekProgressEntity(this.day, this.achievements);

  factory SocialGoalWeekProgressEntity.fromJson(Map<String, dynamic> json) =>
      _$SocialGoalWeekProgressEntityFromJson(json);

  final String day;
  final List<SocialGoalWeekProgressDayAchievementEntity> achievements;

  Map<String, dynamic> toJson() => _$SocialGoalWeekProgressEntityToJson(this);
  SocialGoalWeekProgressDomain toDomain() => SocialGoalWeekProgressDomain(this);

  static List<SocialGoalWeekProgressEntity> getDummy() {
    final days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return List.generate(7, (index) {
      return SocialGoalWeekProgressEntity(
          days[index], SocialGoalWeekProgressDayAchievementEntity.getDummy());
    });
  }
}
