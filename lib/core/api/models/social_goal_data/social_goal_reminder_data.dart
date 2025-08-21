import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/social_goal_entity/social_goal_reminder_entity.dart';

part 'social_goal_reminder_data.g.dart';

@JsonSerializable()
class SocialGoalReminderData {
  SocialGoalReminderData(this.sentBy, this.sentDate);

  factory SocialGoalReminderData.fromJson(Map<String, dynamic> json) =>
      _$SocialGoalReminderDataFromJson(json);

  @JsonKey(name: 'send_by')
  final String sentBy;
  @JsonKey(name: 'send_date')
  final String sentDate;

  Map<String, dynamic> toJson() => _$SocialGoalReminderDataToJson(this);

  SocialGoalReminderEntity asEntity() =>
      SocialGoalReminderEntity(sentBy, sentDate);
}
