import 'package:json_annotation/json_annotation.dart';

import '../../domain_models/notification_count_domain.dart';

part 'notification_count_entity.g.dart';

@JsonSerializable()
class NotificationCountEntity {
  NotificationCountEntity(this.count);

  factory NotificationCountEntity.fromJson(Map<String, dynamic> json) =>
      _$NotificationCountEntityFromJson(json);

  final int count;

  Map<String, dynamic> toJson() => _$NotificationCountEntityToJson(this);
  NotificationCountDomain toDomain() => NotificationCountDomain(this);
}
