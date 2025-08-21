import 'package:echowater/core/domain/domain_models/social_goal_participant_domain.dart';
import 'package:echowater/core/domain/entities/user_entity/user_entity.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain_models/user_domain.dart';

part 'social_goal_participant_entity.g.dart';

@JsonSerializable()
class SocialGoalParticipantEntity {
  SocialGoalParticipantEntity(this.hasAchievedSocialGoal, this.user);

  factory SocialGoalParticipantEntity.fromJson(Map<String, dynamic> json) =>
      _$SocialGoalParticipantEntityFromJson(json);

  final bool hasAchievedSocialGoal;
  final UserEntity user;

  Map<String, dynamic> toJson() => _$SocialGoalParticipantEntityToJson(this);
  SocialGoalParticipantDomain toDomain(bool isMe) =>
      SocialGoalParticipantDomain(this, isMe);

  static List<SocialGoalParticipantEntity> getDummy(UserDomain me) {
    return List.generate(2, (index) {
      return SocialGoalParticipantEntity(
          true, index == 0 ? me.userEntity : UserEntity.dummy(id: '2'));
    });
  }
}
