import 'package:echowater/base/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../base/utils/images.dart';

enum PersonalGoalOption {
  shareCompletedGoal,
  editGoal,
  deleteGoal;

  String get title {
    switch (this) {
      case PersonalGoalOption.shareCompletedGoal:
        return 'GoalOption_shareCompletedGoal'.localized;
      case PersonalGoalOption.editGoal:
        return 'GoalOption_editGoal'.localized;
      case PersonalGoalOption.deleteGoal:
        return 'GoalOption_deleteGoal'.localized;
    }
  }

  Widget? get icon {
    switch (this) {
      case PersonalGoalOption.shareCompletedGoal:
        return SvgPicture.asset(Images.shareIconSVG);
      case PersonalGoalOption.editGoal:
        return SvgPicture.asset(Images.editIconSVG);
      case PersonalGoalOption.deleteGoal:
        return SvgPicture.asset(Images.deleteIconSVG);
    }
  }
}
