import 'package:echowater/base/utils/date_utils.dart';
import 'package:echowater/core/domain/domain_models/friend_request_domain.dart';
import 'package:echowater/core/domain/entities/notification_entity/custom_notification_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

import '../../../theme/app_theme_manager.dart';
import '../entities/friend_entity/friend_request_entity.dart';
import '../entities/notification_entity/notification_entity.dart';
import '../entities/user_entity/user_entity.dart';
import 'notification_type.dart';

class NotificationDomain extends Equatable {
  const NotificationDomain(this._notificationEntity);

  final NotificationEntity _notificationEntity;

  @override
  List<Object?> get props => [_notificationEntity.id];

  String createdDate() {
    final dateTime = DateTime.parse(_notificationEntity.createdAt);
    return DateFormat('MMMM d, y h:mm a').format(dateTime);
  }

  DateTime? get notificationDate => DateTime.tryParse(_notificationEntity.createdAt)?.toLocal();

  String get humanReadableCreatedDate =>
      notificationDate?.humanReadableDateString(hasShortHad: true, format: 'MMM dd HH:mm a') ?? '';

  int get id => _notificationEntity.id;

  bool get isRead => _notificationEntity.isRead;

  String get message => _notificationEntity.message;

  String? get imageUrl => _notificationEntity.customNotificationEntity?.image;

  String? get externalUrl => _notificationEntity.customNotificationEntity?.url;

  bool get isPromotionalNotification => _notificationEntity.notificationType == NotificationType.promotionalArticle.key;

  NotificationType get notificationType =>
      NotificationType.values.firstWhereOrNull((item) => item.key == _notificationEntity.notificationType) ??
      NotificationType.unknown;

  String? get firstImage => _notificationEntity.images.firstOrNull;

  CustomNotificationEntity? get customNotificationEntity => _notificationEntity.customNotificationEntity;

  FriendRequestDomain? getFriendRequestForNotification() {
    if (customNotificationEntity != null && customNotificationEntity?.friendId != null) {
      return FriendRequestDomain(FriendRequestEntity(
          customNotificationEntity!.friendId ?? '',
          UserEntity(
              customNotificationEntity?.friendId ?? '',
              '',
              customNotificationEntity?.firstName ?? '',
              '',
              customNotificationEntity?.lastName ?? '',
              'US',
              '1',
              firstImage,
              AppThemeManager().currentAppTheme.key,
              true,
              false,
              0,
              0,
              '',
              '',
              false)));
    }
    return null;
  }

  String? get friendRequestFriendId => customNotificationEntity?.friendId;
}
