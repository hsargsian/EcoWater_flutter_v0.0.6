import 'package:echowater/core/domain/domain_models/social_goal_week_progress_day_achievement_domain.dart';
import 'package:echowater/core/domain/entities/social_goal_entity/social_goal_week_progress_entity.dart';

class SocialGoalWeekProgressDomain {
  SocialGoalWeekProgressDomain(this._entity);
  final SocialGoalWeekProgressEntity _entity;

  String get dayInitial => _entity.day[0].toUpperCase();

  List<SocialGoalWeekProgressDayAchievementDomain> get dayAchievements =>
      _entity.achievements
          .map(SocialGoalWeekProgressDayAchievementDomain.new)
          .toList();
  bool get isAcheived =>
      dayAchievements.where((item) => !item.isAcheived).isEmpty;
}
