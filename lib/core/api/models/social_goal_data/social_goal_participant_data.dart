import 'package:echowater/core/api/models/user_data/user_data.dart';
import 'package:echowater/core/domain/entities/social_goal_entity/social_goal_participant_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'social_goal_participant_data.g.dart';

@JsonSerializable()
class SocialGoalParticipantData {
  SocialGoalParticipantData(this.hasAchievedSocialGoal, this.user);

  factory SocialGoalParticipantData.fromJson(Map<String, dynamic> json) =>
      _$SocialGoalParticipantDataFromJson(json);

  @JsonKey(name: 'has_achieved_social_goal')
  final bool hasAchievedSocialGoal;
  final UserData user;

  Map<String, dynamic> toJson() => _$SocialGoalParticipantDataToJson(this);

  SocialGoalParticipantEntity asEntity() =>
      SocialGoalParticipantEntity(hasAchievedSocialGoal, user.asEntity());
}
