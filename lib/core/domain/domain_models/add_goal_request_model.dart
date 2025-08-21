import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/core/domain/domain_models/user_domain.dart';

import '../../../base/app_specific_widgets/bottle_and_ppm_view/bottles_and_ppm_selector.dart';

class AddGoalRequestModel {
  AddGoalRequestModel(this.goalTitle, this.goalType, this.goalNumber,
      this.participant, this.isPersonalGoal);
  final String goalTitle;
  final BottleOrPPMType goalType;
  final int goalNumber;
  final UserDomain? participant;
  final bool isPersonalGoal;

  final List<String> _validationErrors = [];

  bool get hasError {
    return _validationErrors.isNotEmpty;
  }

  String get title => goalTitle.trim();

  String get formattedErrorMessage {
    return _validationErrors.map((e) => e.localized).join('\n');
  }

  AddGoalRequestModel? validate() {
    if (!isPersonalGoal) {
      if (title.isEmpty) {
        _validationErrors.add('AddGoal_validationMessage_addTitleMessage');
      }

      if (participant == null) {
        _validationErrors.add('AddGoal_validationMessage_addFriendMessage');
      }
    }
    return hasError ? this : null;
  }
}
