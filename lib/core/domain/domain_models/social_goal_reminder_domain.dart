import 'package:echowater/base/utils/date_utils.dart';
import 'package:echowater/core/domain/entities/social_goal_entity/social_goal_reminder_entity.dart';

import 'user_domain.dart';

class SocialGoalReminderDomain {
  SocialGoalReminderDomain(this._entity, this.me);
  final SocialGoalReminderEntity _entity;
  final UserDomain me;

  bool get isToday =>
      DateUtil.getDateObj('yyyy-MM-dd hh:mm:ss', _entity.sentDate, isUTC: true)
          .toLocal()
          .isToday;
  bool get isByMe => _entity.sentBy == me.id;
}
