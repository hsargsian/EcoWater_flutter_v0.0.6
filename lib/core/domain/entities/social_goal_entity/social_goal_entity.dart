import 'package:echowater/core/domain/domain_models/social_goal_domain.dart';
import 'package:echowater/core/domain/domain_models/user_domain.dart';
import 'package:echowater/core/domain/entities/social_goal_entity/social_goal_reminder_entity.dart';
import 'package:echowater/core/domain/entities/user_entity/user_entity.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../base/app_specific_widgets/bottle_and_ppm_view/bottles_and_ppm_selector.dart';
import 'social_goal_participant_entity.dart';
import 'social_goal_week_progress_entity.dart';

part 'social_goal_entity.g.dart';

@JsonSerializable()
class SocialGoalEntity {
  SocialGoalEntity(
    this.id,
    this.name,
    this.bottlePPMType,
    this.totalValue,
    this.weekprogress,
    this.participants,
    this.creator,
    this.reminder,
    this.isDummy,
  );
  SocialGoalEntity.dummy(UserDomain me, {this.isDummy = true})
      : id = '-1',
        name = 'Goal with Friend',
        bottlePPMType = BottleOrPPMType.bottle.key,
        totalValue = 100,
        weekprogress = SocialGoalWeekProgressEntity.getDummy(),
        participants = SocialGoalParticipantEntity.getDummy(me),
        creator = me.userEntity,
        reminder = null;

  factory SocialGoalEntity.fromJson(Map<String, dynamic> json) => _$SocialGoalEntityFromJson(json);

  final String id;
  final String name;
  final String bottlePPMType;
  final int totalValue;
  final List<SocialGoalWeekProgressEntity> weekprogress;
  final List<SocialGoalParticipantEntity> participants;
  final UserEntity creator;
  final SocialGoalReminderEntity? reminder;
  final bool isDummy;

  Map<String, dynamic> toJson() => _$SocialGoalEntityToJson(this);
  SocialGoalDomain toDomain(DateTime date, UserDomain me) => SocialGoalDomain(this, date, me);
}
