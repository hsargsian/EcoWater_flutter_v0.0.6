import 'package:json_annotation/json_annotation.dart';

import '../../domain_models/notification_wrapper_domain.dart';
import '../page_meta_entity/page_meta_entity.dart';
import 'notification_entity.dart';

part 'notification_wrapper_entity.g.dart';

@JsonSerializable()
class NotificationWrapperEntity {
  NotificationWrapperEntity(
    this.notifications,
    this.pageMeta,
  );

  factory NotificationWrapperEntity.fromJson(Map<String, dynamic> json) =>
      _$NotificationWrapperEntityFromJson(json);

  final List<NotificationEntity> notifications;
  final PageMetaEntity pageMeta;

  Map<String, dynamic> toJson() => _$NotificationWrapperEntityToJson(this);
  NotificationWrapperDomain toDomain() => NotificationWrapperDomain(
      pageMeta.hasMore, notifications.map((e) => e.toDomain()).toList());
}
