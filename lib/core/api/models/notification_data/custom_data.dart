import 'package:echowater/core/domain/entities/notification_entity/custom_notification_entity.dart';
import 'package:json_annotation/json_annotation.dart';
part 'custom_data.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CustomData {
  CustomData(
      {this.socialGoalId,
      this.friendId,
      this.firstName,
      this.lastName,
      this.url,
      this.image});

  factory CustomData.fromJson(Map<String, dynamic> json) =>
      _$CustomDataFromJson(json);
  final String? socialGoalId;
  final String? friendId;
  final String? firstName;
  final String? lastName;
  final String? url;
  final String? image;

  Map<String, dynamic> toJson() => _$CustomDataToJson(this);

  CustomNotificationEntity asEntity() => CustomNotificationEntity(
      socialGoalId, friendId, firstName, lastName, url, image);
}
