import 'dart:io';

import 'package:dio/dio.dart';
import 'package:echowater/core/api/models/empty_success_response/api_success_message_response.dart';
import 'package:echowater/core/api/models/settings_data/settings_data.dart';
import 'package:echowater/core/api/models/walk_through_progress_data/walk_through_progress_data.dart';

import '../../../api/clients/rest_client/authorized_api_client/authorized_api_client.dart';
import '../../../api/exceptions/exception_handler.dart';
import '../../../api/models/empty_success_response/empty_success_response.dart';
import '../../../api/models/user_data/user_data.dart';
import '../../../api/models/user_data_wrapper/user_data_wrapper.dart';

abstract class UserRemoteDataSource {
  Future<UserData> getUserDetail();

  Future<ApiSuccessMessageResponse> changePassword(
      {required String currentPassword, required String newPassword, required String confirmPassword});

  Future<UserData> getProfileInformation(String id);

  Future<UserData> updateProfileImage({required File image});

  Future<UserData> updateUser(
      String firstName, String lastName, String phoneNumber, String countryName, String countryCode, File? avatar);

  Future<UserData> updateUserHealthkitIntegration(bool isHealthIntegrationEnabled);

  Future<UserData> updateTheme({required String userId, required String theme});

  Future<ApiSuccessMessageResponse> logOut({required String refreshToken});

  Future<SettingsData> updateSettings({required Map<String, bool> settings});

  Future<SettingsData> fetchSettings();

  Future<EmptySuccessResponse> deleteAccount();

  Future<WalkThroughProgressData> fetchWalkthroughProgress();

  Future<WalkThroughProgressData> updateWalkthroughProgress(Map<String, bool> data);

  Future<UserDataWrapper> searchUsers(
      {required int offset, required int perPage, required String searchString, required bool isFriendList});
}

class UserRemoteDataSourceImpl extends UserRemoteDataSource {
  UserRemoteDataSourceImpl({required AuthorizedApiClient userApiClient}) : _userApiClient = userApiClient;

  CancelToken _profileImageUpdateCancelToken = CancelToken();
  CancelToken _profileThemeUpdateCancelToken = CancelToken();
  CancelToken _updateUserCancelToken = CancelToken();
  CancelToken _searchUserCancelToken = CancelToken();
  final AuthorizedApiClient _userApiClient;

  @override
  Future<ApiSuccessMessageResponse> changePassword(
      {required String currentPassword, required String newPassword, required String confirmPassword}) async {
    try {
      return await _userApiClient.changePassword(currentPassword, newPassword, confirmPassword);
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<ApiSuccessMessageResponse> logOut({required String refreshToken}) async {
    try {
      return await _userApiClient.logOut(refreshToken);
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<EmptySuccessResponse> deleteAccount() async {
    try {
      return await _userApiClient.deleteAccount();
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<UserData> getUserDetail() async {
    try {
      return await _userApiClient.fetchUserDetail();
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<UserData> updateUser(
    String firstName,
    String lastName,
    String phoneNumber,
    String countryName,
    String countryCode,
    File? avatar,
  ) async {
    try {
      _updateUserCancelToken.cancel();
      _updateUserCancelToken = CancelToken();
      final profileUpdateResponse = await _userApiClient.updateUser(
          firstName, lastName, phoneNumber, countryName, countryCode, avatar, _updateUserCancelToken);
      return profileUpdateResponse;
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<UserData> updateUserHealthkitIntegration(bool isHealthIntegrationEnabled) async {
    try {
      _updateUserCancelToken.cancel();
      _updateUserCancelToken = CancelToken();
      final profileUpdateResponse =
          await _userApiClient.updateUserHealthkitIntegration(isHealthIntegrationEnabled, _updateUserCancelToken);
      return profileUpdateResponse;
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<UserData> updateProfileImage({required File image}) async {
    _profileImageUpdateCancelToken.cancel();
    _profileImageUpdateCancelToken = CancelToken();
    try {
      return await _userApiClient.updateProfileImage(
        image,
      );
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<UserData> updateTheme({required String userId, required String theme}) async {
    try {
      _profileThemeUpdateCancelToken.cancel();
      _profileThemeUpdateCancelToken = CancelToken();
      return await _userApiClient.updateTheme(userId, theme, _profileThemeUpdateCancelToken);
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<UserData> getProfileInformation(String id) async {
    try {
      return await _userApiClient.fetchOtherUserDetail(id);
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<SettingsData> updateSettings({required Map<String, bool> settings}) async {
    try {
      return await _userApiClient.updateSettings(settings);
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<SettingsData> fetchSettings() async {
    try {
      return await _userApiClient.fetchSettings();
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<WalkThroughProgressData> fetchWalkthroughProgress() async {
    try {
      return await _userApiClient.fetchWalkthroughProgress();
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<WalkThroughProgressData> updateWalkthroughProgress(Map<String, bool> data) async {
    try {
      return await _userApiClient.updateWalkthroughProgress(data);
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<UserDataWrapper> searchUsers(
      {required int offset, required int perPage, required String searchString, required bool isFriendList}) async {
    try {
      _searchUserCancelToken.cancel();
      _searchUserCancelToken = CancelToken();
      return await _userApiClient.searchUsers(
          offset, perPage, searchString, isFriendList ? 'true' : 'false', _searchUserCancelToken);
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }
}
