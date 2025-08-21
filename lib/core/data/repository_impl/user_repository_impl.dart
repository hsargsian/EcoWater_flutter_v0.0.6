import 'dart:async';
import 'dart:io';

import 'package:echowater/core/domain/entities/settings_entity/settings_entity.dart';
import 'package:echowater/core/domain/entities/user_entity/users_wrapper_entity.dart';
import 'package:echowater/core/domain/entities/walk_through_progress_entity/walk_through_progress_entity.dart';

import '../../api/exceptions/custom_exception.dart';
import '../../api/resource/resource.dart';
import '../../domain/entities/api_success_message_response_entity/api_success_message_response_entity.dart';
import '../../domain/entities/user_entity/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../data_sources/user_data_sources/user_local_datasource.dart';
import '../data_sources/user_data_sources/user_remote_datasource.dart';

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl({required UserRemoteDataSource remoteDataSource, required UserLocalDataSource localDataSource})
      : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  final UserRemoteDataSource _remoteDataSource;
  final UserLocalDataSource _localDataSource;

  @override
  Future<Result<UserEntity>> fetchUserDetails() async {
    try {
      final userResponse = await _remoteDataSource.getUserDetail();
      final userEntity = userResponse.asEntity();
      await _localDataSource.saveUser(userEntity);
      return Result.success(userEntity);
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<UserEntity>> fetchProfileInformation({required String userId}) async {
    try {
      final userResponse = await _remoteDataSource.getProfileInformation(userId);
      final userEntity = userResponse.asEntity();
      return Result.success(userEntity);
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<UserEntity?> getCurrentUserFromCache() async {
    try {
      final cachedUserInfo = await _localDataSource.getUserDetails();
      if (cachedUserInfo != null) {
        return cachedUserInfo;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<String?> getCurrentUserId() async {
    return _localDataSource.getCurrentUserId();
  }

  @override
  Future<Result<ApiSuccessMessageResponseEntity>> changePassword(
      {required String currentPassword, required String newPassword, required String confirmPassword}) async {
    try {
      final response = await _remoteDataSource.changePassword(
          currentPassword: currentPassword, newPassword: newPassword, confirmPassword: confirmPassword);
      return Future.value(Result.success(response.asEntity()));
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<ApiSuccessMessageResponseEntity>> logOut() async {
    try {
      final refreshToken = await _localDataSource.getRefreshToken();
      final response = await _remoteDataSource.logOut(refreshToken: refreshToken!);
      return Result.success(response.asEntity());
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<UserEntity>> updateProfileImage({
    required File image,
  }) async {
    try {
      final response = await _remoteDataSource.updateProfileImage(
        image: image,
      );
      return Result.success(response.asEntity());
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<UserEntity>> updateTheme({required String userId, required String theme}) async {
    try {
      final response = await _remoteDataSource.updateTheme(userId: userId, theme: theme);

      return Result.success(response.asEntity());
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<bool>> deleteAccount() async {
    try {
      await _remoteDataSource.deleteAccount();
      return const Result.success(true);
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<void> clearUserCache() async {
    final _ = await _localDataSource.logoutUser();
    return Future.value();
  }

  @override
  Future<Result<UserEntity>> updateUser(
      String firstName, String lastName, String phoneNumber, String countryName, String countryCode, File? avatar) async {
    try {
      final updateResponse = await _remoteDataSource.updateUser(
        firstName,
        lastName,
        phoneNumber,
        countryName,
        countryCode,
        avatar,
      );
      final userEntity = updateResponse.asEntity();
      await _localDataSource.saveUser(userEntity);
      return Result.success(userEntity);
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<UserEntity>> updateUserHealthkitIntegrationPreference(bool isHealthIntegrationEnabled) async {
    try {
      final updateResponse = await _remoteDataSource.updateUserHealthkitIntegration(isHealthIntegrationEnabled);
      final userEntity = updateResponse.asEntity();
      await _localDataSource.saveUser(userEntity);
      return Result.success(userEntity);
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<SettingsEntity>> updateSettings({required Map<String, bool> settings}) async {
    try {
      final response = await _remoteDataSource.updateSettings(settings: settings);
      return Future.value(Result.success(response.asEntity()));
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<SettingsEntity>> fetchSettings() async {
    try {
      final response = await _remoteDataSource.fetchSettings();
      return Future.value(Result.success(response.asEntity()));
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<WalkThroughProgressEntity>> fetchWalkthroughProgress() async {
    try {
      final response = await _remoteDataSource.fetchWalkthroughProgress();
      return Future.value(Result.success(response.asEntity()));
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<WalkThroughProgressEntity>> updateWalkthroughProgress(Map<String, bool> data) async {
    try {
      final response = await _remoteDataSource.updateWalkthroughProgress(data);
      return Future.value(Result.success(response.asEntity()));
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<UsersWrapperEntity>> search(
      {required int offset, required int perPage, required String searchString, required bool isFriendList}) async {
    try {
      final response = await _remoteDataSource.searchUsers(
          offset: offset, perPage: perPage, searchString: searchString, isFriendList: isFriendList);
      return Future.value(Result.success(response.asEntity()));
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }
}
