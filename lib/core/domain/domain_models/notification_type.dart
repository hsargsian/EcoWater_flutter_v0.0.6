enum NotificationType {
  personalBottleGoalCompletion,
  personalHydrogenGoalCompletion,
  personalWaterGoalCompletion,
  teamBottleGoalCompletion,
  teamHydrogenGoalCompletion,
  teamWaterGoalCompletion,
  teamBottleGoalCompletionByFriend,
  teamHydrogenGoalCompletionByFriend,
  teamWaterGoalCompletionByFriend,
  friendRequestAccepted,
  friendRequestCreated,
  promotionalContents,
  teamGoalCreation,
  promotionalArticle,
  promotionalVideo,
  friendReminder,
  cleanFlaskReminder,
  teamGoalRemoval,
  teamGoalUpdate,
  appSetupCompletion,
  trainingReminder,
  trainingCompletedReminder,
  usageStreakCompletedReminder,
  flaskCycleCompletion,
  friendGoalStreakCompletedReminder,
  dailyHydrationReminder,
  articleNotificationReminder,
  goalStreakCompletion,
  protocolNotification,
  unknown;

  String get key {
    switch (this) {
      case NotificationType.personalBottleGoalCompletion:
        return 'personal_bottle_goal_completion';
      case NotificationType.personalHydrogenGoalCompletion:
        return 'personal_hydrogen_goal_completion';
      case NotificationType.personalWaterGoalCompletion:
        return 'personal_water_goal_completion';
      case NotificationType.teamBottleGoalCompletion:
        return 'team_bottle_goal_completion';
      case NotificationType.teamHydrogenGoalCompletion:
        return 'team_hydrogen_goal_completion';
      case NotificationType.teamWaterGoalCompletion:
        return 'team_water_goal_completion';
      case NotificationType.teamBottleGoalCompletionByFriend:
        return 'team_bottle_goal_completion_by_friend';
      case NotificationType.teamHydrogenGoalCompletionByFriend:
        return 'team_hydrogen_goal_completion_by_friend';
      case NotificationType.teamWaterGoalCompletionByFriend:
        return 'team_water_goal_completion_by_friend';
      case NotificationType.friendRequestAccepted:
        return 'friend_request_accepted';
      case NotificationType.friendRequestCreated:
        return 'friend_request_created';
      case NotificationType.promotionalContents:
        return 'promotional_contents';
      case NotificationType.teamGoalCreation:
        return 'team_goal_creation';
      case NotificationType.promotionalArticle:
        return 'promotional_article';
      case NotificationType.promotionalVideo:
        return 'promotional_video';
      case NotificationType.friendReminder:
        return 'friend_reminder';
      case NotificationType.cleanFlaskReminder:
        return 'clean_flask_reminder';
      case NotificationType.teamGoalRemoval:
        return 'team_goal_removal';
      case NotificationType.teamGoalUpdate:
        return 'team_goal_update';
      case NotificationType.appSetupCompletion:
        return 'app_setup_completion';
      case NotificationType.trainingReminder:
        return 'training_reminder';
      case NotificationType.trainingCompletedReminder:
        return 'training_completed_reminder';
      case NotificationType.usageStreakCompletedReminder:
        return 'usage_streak_completed_reminder';
      case NotificationType.flaskCycleCompletion:
        return 'flask_cycle_completion';
      case NotificationType.friendGoalStreakCompletedReminder:
        return 'friend_goal_streak_completed_reminder';
      case NotificationType.dailyHydrationReminder:
        return 'daily_hydration_reminder';
      case NotificationType.articleNotificationReminder:
        return 'article_notification_reminder';
      case NotificationType.goalStreakCompletion:
        return 'goal_streak_completion';
      case NotificationType.protocolNotification:
        return 'protocol_notification';
      case NotificationType.unknown:
        return 'Unknown';
    }
  }
}

extension MyIterable<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;

  T? firstWhereOrNull(bool Function(T element) test) {
    final list = where(test);
    return list.isEmpty ? null : list.first;
  }
}
