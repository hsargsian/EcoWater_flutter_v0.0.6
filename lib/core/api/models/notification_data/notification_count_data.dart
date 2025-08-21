import 'package:echowater/core/domain/entities/notification_entity/notification_count_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification_count_data.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class NotificationCountData {
  NotificationCountData(this.count);

  factory NotificationCountData.fromJson(Map<String, dynamic> json) =>
      _$NotificationCountDataFromJson(json);

  final int count;

  Map<String, dynamic> toJson() => _$NotificationCountDataToJson(this);

  NotificationCountEntity asEntity() => NotificationCountEntity(count);
}
