import 'package:echowater/base/utils/date_utils.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/core/domain/domain_models/social_goal_participant_domain.dart';
import 'package:echowater/core/domain/domain_models/social_goal_reminder_domain.dart';
import 'package:echowater/core/domain/domain_models/social_goal_week_progress_domain.dart';
import 'package:echowater/core/domain/domain_models/user_domain.dart';
import 'package:echowater/core/domain/entities/social_goal_entity/social_goal_entity.dart';
import 'package:echowater/core/domain/entities/user_entity/user_entity.dart';
import 'package:equatable/equatable.dart';

import '../../../base/app_specific_widgets/bottle_and_ppm_view/bottles_and_ppm_selector.dart';
import '../../../base/app_specific_widgets/bottle_and_ppm_view/cycle_selector_view.dart';
import 'personal_goal_domain.dart';
import 'personal_goal_option.dart';

class SocialGoalDomain extends Equatable {
  SocialGoalDomain(this._entity, this.date, this.me);

  final SocialGoalEntity _entity;
  final UserDomain me;
  final DateTime date;

  String get id => _entity.id;

  @override
  List<Object?> get props => [id];

  String get actionsheetTitle => bottlePPmType.key == BottleOrPPMType.bottle.key
      ? 'Team Flasks Goal'
      : bottlePPmType.key == BottleOrPPMType.water.key
          ? 'Team Water Goal'
          : 'Team H2 Goal';

  bool get isPastGoal => date.isDateInPast;

  bool get isTodayGoal => date.isToday;

  bool get canRemindPartner => isTodayGoal && !isAchievedByOtherParticipant();

  BottleOrPPMType get bottlePPmType => _entity.bottlePPMType == BottleOrPPMType.ppms.key
      ? BottleOrPPMType.ppms
      : _entity.bottlePPMType == BottleOrPPMType.bottle.key
          ? BottleOrPPMType.bottle
          : BottleOrPPMType.water;

  GoalType get goalType => GoalType.team;

  String get title => _entity.name; //goalType.title(bottlePPmType);

  List<PersonalGoalOption> getGoalOptions() {
    final options = <PersonalGoalOption>[];
    if (participants.map((item) => item.participantUserDomain).toList().contains(me)) {
      if (isGoalCompleted) {
        options.add(PersonalGoalOption.shareCompletedGoal);
      }
      if (isMyGoal && !isPastGoal) {
        options.add(PersonalGoalOption.editGoal);
      }
      if (!isPastGoal) {
        options.add(PersonalGoalOption.deleteGoal);
      }
    } else {
      return [];
    }

    return options;
  }

  String get reminderSendActionSheetMessage => haveISentReminder()
      ? 'You have already sent a reminder, Do you want to remind again?'
      : 'Do you want to remind ${otherParticipant()?.participantUserDomain.firstName ?? ''} about the goal?';

  int get total => _entity.totalValue;

  CycleNumberEnum cycleNumber() {
    if (BottleOrPPMType.bottle.key.contains(_entity.bottlePPMType)) {
      return CycleNumberEnum.one;
    }

    if (_entity.totalValue == 1) {
      return CycleNumberEnum.one;
    } else if (_entity.totalValue == 2) {
      return CycleNumberEnum.two;
    } else if (_entity.totalValue == 3) {
      return CycleNumberEnum.three;
    } else {
      return CycleNumberEnum.more;
    }
  }

  bool get isMyGoal => _entity.creator.id == me.id;

  // BottleOrPPMType get selectedPPMType => bottlePPmType == BottleOrPPMType.bottle.key;

  bool get isDummyGoal => _entity.isDummy;

  bool get canPerformGoalActions => _entity.creator.id == me.id;

  String dummyTitle = '';

  String get addGoalTitle => bottlePPmType == BottleOrPPMType.bottle
      ? dummyTitle.isEmpty
          ? 'Create_team_goal'.localized
          : dummyTitle
      : 'TeamH2Goal'.localized;

  bool get isGoalCompleted => isAcheivedByBoth;

  static List<SocialGoalDomain> dummyGoals() {
    final me = UserEntity.dummy();

    return [
      SocialGoalDomain(SocialGoalEntity.dummy(UserDomain(me, true), isDummy: false), DateTime.now(), UserDomain(me, true)),
    ];
  }

  List<SocialGoalParticipantDomain> get participants =>
      _entity.participants.map((item) => SocialGoalParticipantDomain(item, item.user.id == me.id)).toList();

  List<SocialGoalWeekProgressDomain> get daysDomain => _entity.weekprogress.map(SocialGoalWeekProgressDomain.new).toList();

  String get totalText => bottlePPmType.key == BottleOrPPMType.bottle.key
      ? '${_entity.totalValue}'
      : bottlePPmType.key == BottleOrPPMType.water.key
          ? '${_entity.totalValue} Ounce'
          : '${_entity.totalValue} ${'h2'.localized}';

  String get goalTypeText => bottlePPmType.key == BottleOrPPMType.bottle.key
      ? 'Team Daily Flasks'
      : bottlePPmType.key == BottleOrPPMType.water.key
          ? 'Team Daily Water'
          : 'Team Daily H2';

  bool isAchievedByMe() {
    final meArray = participants.where((item) => item.isMe);
    if (meArray.isEmpty) {
      return false;
    }
    return meArray.first.hasAchieved;
  }

  SocialGoalParticipantDomain? otherParticipant() {
    final otherArray = participants.where((item) => !item.isMe);
    if (otherArray.isEmpty) {
      return null;
    }
    return otherArray.first;
  }

  SocialGoalReminderDomain? get reminder => _entity.reminder?.toDomain(me);

  bool haveISentReminder() {
    if (reminder == null) {
      return false;
    }
    return reminder!.isToday && reminder!.isByMe;
  }

  bool get isAcheivedByBoth => isAchievedByMe() && isAchievedByOtherParticipant();

  bool isAchievedByOtherParticipant() {
    return otherParticipant()?.hasAchieved ?? false;
  }
}
