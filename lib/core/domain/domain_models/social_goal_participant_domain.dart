import 'package:echowater/core/domain/domain_models/user_domain.dart';
import 'package:echowater/core/domain/entities/social_goal_entity/social_goal_participant_entity.dart';

class SocialGoalParticipantDomain {
  SocialGoalParticipantDomain(this._entity, this.isMe);
  final SocialGoalParticipantEntity _entity;
  final bool isMe;

  UserDomain get participantUserDomain => UserDomain(_entity.user, isMe);

  bool get hasAchieved => _entity.hasAchievedSocialGoal;

  String get participantId => participantUserDomain.id;
}
