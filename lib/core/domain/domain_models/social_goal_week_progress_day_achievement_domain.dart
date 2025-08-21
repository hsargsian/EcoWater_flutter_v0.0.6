import 'package:echowater/core/domain/entities/social_goal_entity/social_goal_week_progress_day_achievement_entity.dart';

class SocialGoalWeekProgressDayAchievementDomain {
  SocialGoalWeekProgressDayAchievementDomain(this._entity);
  final SocialGoalWeekProgressDayAchievementEntity _entity;
  bool get isAcheived => _entity.hasAchieved;
}
