import 'package:echowater/base/utils/strings.dart';

import 'notification_setting_type.dart';

enum SettingsType {
  emailNotification,
  pushNotification;

  String get navTitle {
    switch (this) {
      case SettingsType.emailNotification:
        return 'profileOption_email_notifications'.localized;
      case SettingsType.pushNotification:
        return 'profileOption_push_notifications'.localized;
    }
  }

  String get description {
    switch (this) {
      case SettingsType.emailNotification:
        return 'profileOption_email_notifications_description'.localized;
      case SettingsType.pushNotification:
        return 'profileOption_push_notifications_description'.localized;
    }
  }

  List<NotificationType> get notificationTypes {
    switch (this) {
      case SettingsType.emailNotification:
        return [
          NotificationType.promotionalEmails,
          NotificationType.accountUpdates
        ];
      case SettingsType.pushNotification:
        return [
          NotificationType.progressNotifications,
          NotificationType.newsNotifications,
          NotificationType.bottleNotifications,
        ];
    }
  }
}
