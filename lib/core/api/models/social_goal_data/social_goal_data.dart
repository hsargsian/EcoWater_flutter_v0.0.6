import 'package:echowater/core/api/models/social_goal_data/social_goal_reminder_data.dart';
import 'package:echowater/core/api/models/social_goal_data/social_goal_week_progress_data.dart';
import 'package:echowater/core/api/models/user_data/user_data.dart';
import 'package:echowater/core/domain/entities/social_goal_entity/social_goal_entity.dart';
import 'package:json_annotation/json_annotation.dart';

import 'social_goal_participant_data.dart';

part 'social_goal_data.g.dart';

@JsonSerializable()
class SocialGoalData {
  SocialGoalData(
      this.id,
      this.name,
      this.bottlePPMType,
      this.totalValue,
      this.weekProgressData,
      this.participants,
      this.creator,
      this.reminderData);

  factory SocialGoalData.fromJson(Map<String, dynamic> json) =>
      _$SocialGoalDataFromJson(json);

  final String id;
  final String name;
  @JsonKey(name: 'goal_type')
  final String bottlePPMType;
  @JsonKey(name: 'goal_number')
  final int totalValue;
  @JsonKey(name: 'weekly_progress_data')
  List<SocialGoalWeekProgressData> weekProgressData;
  List<SocialGoalParticipantData> participants;
  @JsonKey(name: 'created_by')
  final UserData creator;
  @JsonKey(name: 'last_reminder')
  final SocialGoalReminderData? reminderData;

  Map<String, dynamic> toJson() => _$SocialGoalDataToJson(this);

  SocialGoalEntity asEntity() => SocialGoalEntity(
        id,
        name,
        bottlePPMType,
        totalValue,
        weekProgressData.map((item) => item.asEntity()).toList(),
        participants.map((item) => item.asEntity()).toList(),
        creator.asEntity(),
        reminderData?.asEntity(),
        false,
      );
}
