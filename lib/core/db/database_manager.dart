import 'dart:async';
import 'package:hive_flutter/hive_flutter.dart';

import '../data/database/user_collection_impl.dart';

class AppDatabaseManager {
  factory AppDatabaseManager() {
    return _singleton;
  }

  AppDatabaseManager._internal();
  static final AppDatabaseManager _singleton = AppDatabaseManager._internal();

  UserCollectionImpl? _userCollection;

  Future createDatabase() async {
    await Hive.initFlutter();
    initHiveCollections();
  }

  void initHiveCollections() {
    _userCollection = UserCollectionImpl();
    _userCollection?.openBox();
  }

  FutureOr<UserCollectionImpl> get userCollection async {
    if (_userCollection == null) {
      await createDatabase();
    }
    return _userCollection!;
  }

  Future<void> clearAllCache() async {
    await _userCollection?.deleteAllCache();
  }
}
