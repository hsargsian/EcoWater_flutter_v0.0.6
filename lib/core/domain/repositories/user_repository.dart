import 'dart:io';

import 'package:echowater/core/domain/entities/api_success_message_response_entity/api_success_message_response_entity.dart';
import 'package:echowater/core/domain/entities/settings_entity/settings_entity.dart';
import 'package:echowater/core/domain/entities/user_entity/users_wrapper_entity.dart';

import '../../api/resource/resource.dart';
import '../entities/user_entity/user_entity.dart';
import '../entities/walk_through_progress_entity/walk_through_progress_entity.dart';

abstract class UserRepository {
  Future<Result<UserEntity>> fetchUserDetails();

  Future<Result<UserEntity>> fetchProfileInformation({required String userId});

  Future<Result<ApiSuccessMessageResponseEntity>> changePassword(
      {required String currentPassword, required String newPassword, required String confirmPassword});

  Future<UserEntity?> getCurrentUserFromCache();

  Future<String?> getCurrentUserId();

  Future<Result<UserEntity>> updateUser(
      String firstName, String lastName, String phoneNumber, String countryName, String countryCode, File? avatar);

  Future<Result<UserEntity>> updateUserHealthkitIntegrationPreference(bool isHealthIntegrationEnabled);

  Future<Result<UserEntity>> updateProfileImage({
    required File image,
  });

  Future<Result<ApiSuccessMessageResponseEntity>> logOut();

  Future<Result<UsersWrapperEntity>> search(
      {required int offset, required int perPage, required String searchString, required bool isFriendList});

  Future<Result<SettingsEntity>> updateSettings({required Map<String, bool> settings});

  Future<Result<SettingsEntity>> fetchSettings();

  Future<Result<UserEntity>> updateTheme({required String userId, required String theme});

  Future<Result<bool>> deleteAccount();

  Future<void> clearUserCache();

  Future<Result<WalkThroughProgressEntity>> fetchWalkthroughProgress();

  Future<Result<WalkThroughProgressEntity>> updateWalkthroughProgress(Map<String, bool> data);
}
