import 'package:echowater/base/app_specific_widgets/bottle_and_ppm_view/bottles_and_ppm_selector.dart';
import 'package:echowater/base/app_specific_widgets/bottle_and_ppm_view/cycle_selector_view.dart';
import 'package:echowater/base/utils/colors.dart';
import 'package:echowater/base/utils/date_utils.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/core/domain/entities/personal_goal_entity/personal_goal_entity.dart';
import 'package:echowater/theme/app_color_theme.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'personal_goal_option.dart';

class PersonalGoalDomain extends Equatable {
  const PersonalGoalDomain(this._entity, this.date, this.dummyTitle);

  final PersonalGoalEntity _entity;
  final String dummyTitle;
  final DateTime date;

  String get id => _entity.id;

  @override
  List<Object?> get props => [id];

  BottleOrPPMType get bottlePPmType => _entity.bottlePPMType == BottleOrPPMType.ppms.key
      ? BottleOrPPMType.ppms
      : _entity.bottlePPMType == BottleOrPPMType.bottle.key
          ? BottleOrPPMType.bottle
          : BottleOrPPMType.water;

  GoalType get goalType => GoalType.personal;

  String get title => goalType.title(bottlePPmType);

  int get total => _entity.totalValue;

  num get completed => _entity.completedValue;

  CycleNumberEnum cycleNumber() {
    if (isBottleGoal) {
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

    return CycleNumberEnum.one;
  }

  Color progressColor(BuildContext context) {
    if (isBottleGoal) {
      return Theme.of(context).colorScheme.highLightColor;
    } else if (isH2Goal) {
      return Theme.of(context).colorScheme.primary;
    }
    return HexColor.fromHex('#7FA0AC');
  }

  bool get canPerformGoalOptions => getGoalOptions().isNotEmpty;

  bool get isBottleGoal => bottlePPmType == BottleOrPPMType.bottle;

  bool get isH2Goal => bottlePPmType == BottleOrPPMType.ppms;

  bool get isDummyGoal => _entity.isDummy;

  bool get isPastGoal => date.isDateInPast;

  String get addGoalTitle => bottlePPmType == BottleOrPPMType.bottle
      ? dummyTitle.isEmpty
          ? 'Create_personal_goal'.localized
          : dummyTitle
      : bottlePPmType == BottleOrPPMType.water
          ? 'Water Goal'
          : 'H2 Goal';

  bool get isGoalCompleted => _entity.completedValue >= _entity.totalValue;

  String get goalCompletionString => '${"complete".localized} ${_entity.completedValue}/${_entity.totalValue}';

  double get percentageCompleted => _entity.completedValue / _entity.totalValue;

  static List<PersonalGoalDomain> dummyGoals() {
    return [
      PersonalGoalDomain(
          PersonalGoalEntity(
            '1',
            'bottle_goal',
            10,
            5,
            false,
          ),
          DateTime.now(),
          ''),
      PersonalGoalDomain(PersonalGoalEntity('1', 'hydrogen_goal', 100, 70, false), DateTime.now(), ''),
      PersonalGoalDomain(PersonalGoalEntity('1', 'water_goal', 50, 20, false), DateTime.now(), ''),
    ];
  }

  String get actionsheetTitle => bottlePPmType == BottleOrPPMType.bottle
      ? 'Goal_addDailyBottle_goal'.localized
      : bottlePPmType == BottleOrPPMType.ppms
          ? 'Goal_addDailyH2_goal'.localized
          : 'Goal_addDailyWater_goal'.localized;

  String get completedText => isBottleGoal
      ? '${_entity.completedValue} ${flaskText(_entity.completedValue)}'
      : '${_entity.completedValue} mg ${"h2".localized}';

  String get totalText =>
      isBottleGoal ? '${_entity.totalValue} ${flaskText(_entity.totalValue)}' : '${_entity.totalValue} mg ${"h2".localized}';

  List<PersonalGoalOption> getGoalOptions() {
    final options = <PersonalGoalOption>[];
    if (isGoalCompleted) {
      options.add(PersonalGoalOption.shareCompletedGoal);
    }
    if (!isPastGoal) {
      options
        ..add(PersonalGoalOption.editGoal)
        ..add(PersonalGoalOption.deleteGoal);
    }

    return options;
  }

  String flaskText(num count) {
    return count > 1 ? 'flasks'.localized : 'flask'.localized;
  }
}

enum GoalType {
  personal,
  team;

  String title(BottleOrPPMType type) {
    switch (this) {
      case GoalType.personal:
        return '${type.goalTitle} ${"goal".localized}';
      case GoalType.team:
        return '${"team".localized} ${type.goalTitle} ${"goal".localized}';
    }
  }
}
