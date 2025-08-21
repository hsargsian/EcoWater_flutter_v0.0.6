import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/notification_entity/notification_wrapper_entity.dart';
import '../notification_data/notification_data.dart';
import '../page_meta_data/page_meta_data.dart';

part 'notifications_data_wrapper.g.dart';

@JsonSerializable()
class NotificationsDataWrapper {
  NotificationsDataWrapper(this.notifications, this.pageMeta);

  factory NotificationsDataWrapper.fromJson(Map<String, dynamic> json) =>
      _$NotificationsDataWrapperFromJson(json);
  @JsonKey(name: 'results')
  final List<NotificationData> notifications;
  @JsonKey(name: 'meta')
  final PageMetaData pageMeta;

  NotificationWrapperEntity asEntity() => NotificationWrapperEntity(
      notifications.map((e) => e.asEntity()).toList(), pageMeta.asEntity());
}
