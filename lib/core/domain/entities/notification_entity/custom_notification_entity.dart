import 'package:json_annotation/json_annotation.dart';

part 'custom_notification_entity.g.dart';

@JsonSerializable()
class CustomNotificationEntity {
  CustomNotificationEntity(this.socialGoalId, this.friendId, this.firstName,
      this.lastName, this.url, this.image);

  factory CustomNotificationEntity.fromJson(Map<String, dynamic> json) =>
      _$CustomNotificationEntityFromJson(json);

  final String? socialGoalId;
  final String? friendId;
  final String? firstName;
  final String? lastName;
  final String? url;
  final String? image;

  Map<String, dynamic> toJson() => _$CustomNotificationEntityToJson(this);
}
