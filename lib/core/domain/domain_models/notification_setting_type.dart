import 'package:echowater/base/utils/strings.dart';

enum NotificationType {
  promotionalEmails,
  accountUpdates,
  progressNotifications,
  newsNotifications,
  bottleNotifications;

  String get key {
    switch (this) {
      case NotificationType.promotionalEmails:
        return 'promotional_emails';
      case NotificationType.accountUpdates:
        return 'account_updates';
      case NotificationType.progressNotifications:
        return 'progress_notifications';
      case NotificationType.newsNotifications:
        return 'news_notifications';
      case NotificationType.bottleNotifications:
        return 'bottle_notifications';
    }
  }

  String get title {
    switch (this) {
      case NotificationType.promotionalEmails:
        return 'notification_type_promotional_emails'.localized;
      case NotificationType.accountUpdates:
        return 'notification_type_account_updates'.localized;
      case NotificationType.progressNotifications:
        return 'notification_type_progress_notifications'.localized;
      case NotificationType.newsNotifications:
        return 'notification_type_newsNotifications'.localized;
      case NotificationType.bottleNotifications:
        return 'notification_type_bottle_notifications'.localized;
    }
  }
}
