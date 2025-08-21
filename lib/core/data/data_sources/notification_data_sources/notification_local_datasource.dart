import 'package:echowater/core/api/models/notification_data/notification_data.dart';

import '../../../db/database_manager.dart';

abstract class NotificationLocalDataSource {
  Future<List<NotificationData>> getNotifications();
}

class NotificationLocalDataSourceImpl extends NotificationLocalDataSource {
  NotificationLocalDataSourceImpl(
      {required AppDatabaseManager appDatabaseManager})
      : _appDatabaseManager = appDatabaseManager;
  late final AppDatabaseManager _appDatabaseManager;

  @override
  Future<List<NotificationData>> getNotifications() async {
    return [];
  }
}
