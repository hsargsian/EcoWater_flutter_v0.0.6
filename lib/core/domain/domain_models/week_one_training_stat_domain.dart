import 'package:echowater/base/utils/date_utils.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/core/domain/entities/week_one_traning_entity/week_one_training_stat_entity.dart';
import 'package:intl/intl.dart';

import 'user_domain.dart';

class WeekOneTraningStatDomain {
  WeekOneTraningStatDomain(this._entity);
  final WeekOneTrainingStatEntity _entity;

  bool showsWeekOneTraining() {
    if (_entity.weekOneTrainingStartDay == null) {
      return true;
    }
    if (_entity.weekOneTrainingDayProgress <= 7) {
      return true;
    }
    if (_entity.weekOneLastTrainingDay == null) {
      return false;
    }

    final startDate = DateTime.parse(_entity.weekOneLastTrainingDay!);
    final currentDate = DateTime.now();
    if (startDate.year == currentDate.year &&
        startDate.month == currentDate.month &&
        startDate.day == currentDate.day) {
      return true;
    }
    return false;
  }

  void updateWithCurrentUser(UserDomain user) {
    return;
    // we are not updating week training data based on user information.
    // so even if user created account
    final accountCreationDate = user.accountCreationDate!;
    final dateToday = DateTime.now().startOfDay;
    final days = dateToday.difference(accountCreationDate).inDays;
    _entity
      ..weekOneTrainingDayProgress = days
      ..weekOneTrainingStartDay =
          DateFormat('yyyy-MM-dd').format(accountCreationDate);
  }

  void updateWeekTrainingClosed() {
    _entity.hasClosedWeekTraining = true;
  }

  String getCurrentDayText() {
    if (currentDay == 0) {
      return '${"day".localized} 1-7';
    }
    return '${"day".localized} $currentDay';
  }

  int get currentDay => _entity.weekOneTrainingDayProgress;

  bool hasCompletedTraining() {
    return currentDay >= 8;
  }

  bool get hasClosedWeekTraining => _entity.hasClosedWeekTraining;

  int getDay(int currentWeekProgressPage) {
    if (_entity.weekOneLastTrainingDay == null) {
      if (currentWeekProgressPage == 0) {
        return 0;
      }
      return 1;
    }
    final startDate = DateTime.parse(_entity.weekOneLastTrainingDay!);
    final currentDate = DateTime.now();
    if (DateTime(currentDate.year, currentDate.month, currentDate.day)
            .compareTo(startDate) ==
        0) {
      return currentDay;
    }
    return currentDay + 1;
  }
}
