import 'package:echowater/core/domain/entities/user_entity/user_entity.dart';

import '../../../db/database_manager.dart';

abstract class FriendsLocalDataSource {
  Future<List<UserEntity>> getFriends();
}

class FriendsLocalDataSourceImpl extends FriendsLocalDataSource {
  FriendsLocalDataSourceImpl({required AppDatabaseManager appDatabaseManager})
      : _appDatabaseManager = appDatabaseManager;
  late final AppDatabaseManager _appDatabaseManager;

  @override
  Future<List<UserEntity>> getFriends() async {
    return [];
  }
}
