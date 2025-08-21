import 'dart:async';

import 'package:echowater/core/services/marketing_push_service/marketing_push_service.dart';

import '../../../api/exceptions/custom_exception.dart';
import '../../../db/database_manager.dart';
import '../../../domain/entities/user_entity/user_entity.dart';
import '../../../services/local_storage_service/local_storage_service.dart';

abstract class UserLocalDataSource {
  Future<UserEntity?> getUserDetails();
  Future<void> saveUser(UserEntity user);
  Future<void> updateUser(UserEntity user);
  Future<String?> getCurrentUserId();
  Future<String?> getRefreshToken();
  Future<void> logoutUser();
  Future<List<UserEntity>> getUsers(int page, int size);
}

class UserLocalDataSourceImpl extends UserLocalDataSource {
  UserLocalDataSourceImpl(
      {required AppDatabaseManager appDatabaseManager,
      required LocalStorageService localStorageService,
      required MarketingPushService marketingPushService})
      : _appDatabaseManager = appDatabaseManager,
        _localStorageService = localStorageService,
        _marketingPushService = marketingPushService;

  late final AppDatabaseManager _appDatabaseManager;
  final LocalStorageService _localStorageService;
  final MarketingPushService _marketingPushService;

  @override
  Future<UserEntity?> getUserDetails() async {
    final collection = await _appDatabaseManager.userCollection;
    final userId = await _localStorageService.userId;
    if (userId == null) {
      throw CustomException.sessionExpired();
    }
    try {
      await collection.openBox();
      final Map<String, dynamic> userJson = await collection.get(userId);
      final user = UserEntity.fromJson(userJson);
      return user;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveUser(UserEntity user) async {
    _marketingPushService.setUser(user);
    final collection = await _appDatabaseManager.userCollection;
    return collection.addUpdate(user.id, user);
  }

  @override
  Future<void> updateUser(UserEntity user) async {
    _marketingPushService.setUser(user);
    final collection = await _appDatabaseManager.userCollection;
    return collection.addUpdate(user.id, user);
  }

  @override
  Future<String?> getCurrentUserId() async {
    return _localStorageService.userId;
  }

  @override
  Future<String?> getRefreshToken() async {
    return _localStorageService.refreshToken;
  }

  @override
  Future<void> logoutUser() async {
    await _appDatabaseManager.clearAllCache();
    return _localStorageService.clearLocalCache();
  }

  @override
  Future<List<UserEntity>> getUsers(int page, int size) async {
    return [];
  }
}
