import 'package:json_annotation/json_annotation.dart';

import '../../domain_models/social_goal_reminder_domain.dart';
import '../../domain_models/user_domain.dart';

part 'social_goal_reminder_entity.g.dart';

@JsonSerializable()
class SocialGoalReminderEntity {
  SocialGoalReminderEntity(this.sentBy, this.sentDate);

  factory SocialGoalReminderEntity.fromJson(Map<String, dynamic> json) =>
      _$SocialGoalReminderEntityFromJson(json);

  final String sentBy;
  final String sentDate;

  Map<String, dynamic> toJson() => _$SocialGoalReminderEntityToJson(this);
  SocialGoalReminderDomain toDomain(UserDomain me) =>
      SocialGoalReminderDomain(this, me);
}
