import 'dart:io';

import 'package:dio/dio.dart';
import 'package:echowater/core/api/models/empty_success_response/api_success_message_response.dart';
import 'package:echowater/core/api/models/flask_data/flask_data.dart';
import 'package:echowater/core/api/models/friend_requests_wrapper_data/friend_requests_wrapper_data.dart';
import 'package:echowater/core/api/models/friends_wrapper_data/friends_wrapper_data.dart';
import 'package:echowater/core/api/models/learning_urls_data/learning_urls_data.dart';
import 'package:echowater/core/api/models/notification_data/notification_count_data.dart';
import 'package:echowater/core/api/models/personal_goal_graph_data/personal_goal_graph_data.dart';
import 'package:echowater/core/api/models/personal_goal_wrapper_data/personal_goal_wrapper_data.dart';
import 'package:echowater/core/api/models/settings_data/settings_data.dart';
import 'package:echowater/core/api/models/social_goal_wrapper_data/social_goal_wrapper_data.dart';
import 'package:echowater/core/api/models/todays_progress_data/todays_progress_data.dart';
import 'package:echowater/core/api/models/usage_dates_data/usage_dates_data.dart';
import 'package:echowater/core/api/models/usage_streak_data/usage_streak_data.dart';
import 'package:echowater/core/api/models/video_learning_library_wrapper_data/video_learning_library_wrapper_data.dart';
import 'package:echowater/core/api/models/walk_through_progress_data/walk_through_progress_data.dart';
import 'package:echowater/core/api/models/week_one_traning_data/week_one_training_stat_data.dart';
import 'package:http_parser/http_parser.dart';
import 'package:retrofit/retrofit.dart';

import '../../../models/article_learning_library_wrapper_data/article_learning_library_wrapper_data.dart';
import '../../../models/asset_data/asset_data.dart';
import '../../../models/customize_protocol_active_request_model/customize_protocol_active_request_model.dart';
import '../../../models/customize_protocol_model/customize_protocol_model.dart';
import '../../../models/customize_protocol_request_model/customize_protocol_request_model.dart';
import '../../../models/device_ personalization_settings/device_personalization_settings_data.dart';
import '../../../models/empty_success_response/empty_success_response.dart';
import '../../../models/flask_firmware_version_data/flask_firmware_version_data.dart';
import '../../../models/flask_wrapper_data/flask_wrapper_data.dart';
import '../../../models/led_light_color_wrapper_data/led_color_response_wrapper_data.dart';
import '../../../models/notifications_data_wrapper/notifications_data_wrapper.dart';
import '../../../models/protocol_wrapper_data/protocol_category_wrapper_data.dart';
import '../../../models/protocol_wrapper_data/protocol_details_data.dart';
import '../../../models/protocol_wrapper_data/protocol_wrapper_data.dart';
import '../../../models/system_access_info_data/system_access_info_data.dart';
import '../../../models/user_data/user_data.dart';
import '../../../models/user_data_wrapper/user_data_wrapper.dart';
import '../../../models/week_one_traning_data/week_one_training_wrapper_data.dart';

part 'authorized_api_client.g.dart';

@RestApi()
abstract class AuthorizedApiClient {
  factory AuthorizedApiClient(Dio dio, {String baseUrl}) = _AuthorizedApiClient;

  @GET('account-profile')
  Future<UserData> fetchUserDetail();

  @GET('users/{id}')
  Future<UserData> fetchOtherUserDetail(@Path('id') String userId);

  @POST('update-password')
  Future<ApiSuccessMessageResponse> changePassword(
    @Field('old_password') String currentPassword,
    @Field('new_password') String newPassword,
    @Field('confirm_password') String confirmPassword,
  );

  @PATCH('account-profile')
  @MultiPart()
  Future<UserData> updateUser(
      @Field('first_name') String firstName,
      @Field('last_name') String lastName,
      @Field('phone_number') String phoneNumber,
      @Field('country_name') String countryName,
      @Field('country_code') String countryCode,
      @Part(name: 'image') File? file,
      @MultiPart() @CancelRequest() CancelToken cancelToken);

  @PATCH('account-profile')
  Future<UserData> updateUserHealthkitIntegration(
      @Field('is_health_integration_enabled') bool isHealthIntegrationEnabled,
      @CancelRequest() CancelToken cancelToken);

  @PATCH('users/{id}/theme')
  Future<UserData> updateTheme(@Path('id') String id, @Field() String theme,
      @CancelRequest() CancelToken cancelToken);

  @DELETE('users')
  Future<EmptySuccessResponse> deleteAccount();

  @POST('user/set-fcm-token')
  Future<EmptySuccessResponse> updateDevice(
    @Field('token') String pushToken,
    CancelToken updateDeviceCancelToken,
  );

  @POST('auth/logout')
  Future<ApiSuccessMessageResponse> logOut(
      @Field('refresh') String refreshToken);

  @PATCH('user/notification-settings')
  Future<SettingsData> updateSettings(@Body() Map<String, bool> settings);

  @GET('user/notification-settings')
  Future<SettingsData> fetchSettings();

  @GET('user/walkthrough-progress')
  Future<WalkThroughProgressData> fetchWalkthroughProgress();

  @PATCH('user/walkthrough-progress')
  Future<WalkThroughProgressData> updateWalkthroughProgress(
      @Body() Map<String, bool> data);

  @DELETE('pushNotifications/registered_devices/{id}')
  Future<EmptySuccessResponse> removeDevice(
    @Path('id') String deviceId,
  );

  @POST('assets')
  @MultiPart()
  Future<AssetData> uploadAsset(
    @Part() String type,
    @Part() File file,
  );

  //' friends
  @GET('friends/my')
  Future<FriendsWrapperData> fetchFriends(
      @Query('search') String? search,
      @Query('offset') int offset,
      @Query('perPage') int perPage,
      CancelToken cancelToken);

  @POST('friends/request')
  Future<HttpResponse> sendFriendRequest(
      @Field('friend_id') String friendId, CancelToken cancelToken);

  @POST('friends/request-action')
  Future<ApiSuccessMessageResponse> updateFriendRequestAction(
      @Field('friend_id') String friendId,
      @Field('action') String action,
      CancelToken cancelToken);

  @GET('friends/request-received')
  Future<FriendRequestsWrapperData> fetchFriendRequestsReceived(
      @Query('is_ignored') String isIgnored,
      @Query('offset') int offset,
      @Query('perPage') int perPage,
      CancelToken cancelToken);

  @GET('friends/request-sent')
  Future<FriendRequestsWrapperData> fetchFriendRequestsSent(
      @Query('offset') int offset,
      @Query('perPage') int perPage,
      CancelToken cancelToken);

  //users
  @GET('users')
  Future<UserDataWrapper> searchUsers(
      @Query('offset') int offset,
      @Query('perPage') int perPage,
      @Query('search') String searchString,
      @Query('is_friend_list_search') String isFriendListSearch,
      CancelToken cancelToken);

  @GET('users/{id}')
  Future<UserData> userDetails(@Path('id') String id, CancelToken cancelToken);

  // notifications

  @GET('notifications')
  Future<NotificationsDataWrapper> fetchNotifications(
    @Query('offset') int offset,
    @Query('limit') int perPage,
  );

  @DELETE('notifications/{id}')
  Future<HttpResponse> deleteNotification(
    @Path('id') String id,
  );

  @GET('notifications/unread-count')
  Future<NotificationCountData> fetchUnreadNotificationsCount();

  @POST('notifications/read-all')
  Future<NotificationCountData> readUnReadNotiifications();

  //push notifications

  //flask
  @PATCH('ble_device/{id}/pair')
  Future<FlaskData> toggleDevicePair(
      @Path('id') String id, @Field('is_paired') bool isPaired);

  @DELETE('devices/{id}')
  Future<HttpResponse> unpairFlask(
    @Path('id') String id,
  );

  @GET('devices/{id}/clean')
  Future<ApiSuccessMessageResponse> cleanFlask(
    @Path('id') String id,
  );

  @POST('devices/{id}/start-cycle')
  Future<ApiSuccessMessageResponse> startFlaskCycle(
      @Path('id') String id, @Field('ppm_generated') double? ppmGenerated);

  @GET('led-colors')
  Future<LedColorResponseWrapperData> fetchLedColors();

  //learnings
  @GET('support-instructions-urls')
  Future<LearningUrlsData> fetchBaseLearningUrls();

  @GET('learnings/videos')
  Future<VideoLearningLibraryWrapperData> fetchVideoLibrary(
    @Query('offset') int offset,
    @Query('perPage') int perPage,
  );

  @GET('learnings/articles')
  Future<ArticleLearningLibraryWrapperData> fetchArticleLibrary(
    @Query('offset') int offset,
    @Query('perPage') int perPage,
  );

  // social goals

  @GET('users/{id}/social-goals')
  Future<SocialGoalWrapperData> fetchSocialGoals(@Path('id') String userId,
      @Query('date') String date, CancelToken cancelToken);

  @DELETE('social-goals/{id}')
  Future<ApiSuccessMessageResponse> deleteSocialGoal(
      @Path('id') String id, CancelToken cancelToken);

  @POST('social-goals/{id}/remind')
  Future<ApiSuccessMessageResponse> remindSocialGoal(@Path('id') String id,
      @Field('friend_id') String friendId, CancelToken cancelToken);

  @POST('social-goals')
  Future<HttpResponse> addSocialGoal(
      @Field('goal_type') String goalType,
      @Field('goal_number') int goalNumber,
      @Field('participants') List<String> participants,
      @Field('name') String name,
      CancelToken cancelToken);

  @PATCH('social-goals/{id}')
  Future<HttpResponse> updateSocialGoal(
      @Path('id') String goalId,
      @Field('goal_type') String goalType,
      @Field('goal_number') int goalNumber,
      @Field('participants') List<String> participants,
      @Field('name') String name,
      CancelToken cancelToken);

  // personal goals

  @GET('users/{id}/personal-goals')
  Future<PersonalGoalWrapperData> fetchPersonalGoals(@Path('id') String userId,
      @Query('date') String date, CancelToken cancelToken);

  @DELETE('personal-goals/{id}')
  Future<ApiSuccessMessageResponse> deletePersonalGoal(
      @Path('id') String id, CancelToken cancelToken);

  @POST('personal-goals')
  Future<ApiSuccessMessageResponse> addPersonalGoal(
      @Field('goal_type') String goalType,
      @Field('goal_number') int goalNumber,
      CancelToken cancelToken);

  @GET('usage-dates')
  Future<UsageDatesData> fetchUsageDates(@Query('start_date') String startDate,
      @Query('end_date') String endDate, CancelToken cancelToken);

  @GET('dashboard-data')
  Future<UsageStreakData> fetchUsageStreak(CancelToken cancelToken);

  @GET('personal-goal/chart-data')
  Future<List<PersonalGoalGraphData>> fetchPersonalGoalGraphData(
      @Query('start-date') String startDate,
      @Query('end-date') String endDate,
      @Query('goal-type') String goalType,
      CancelToken cancelToken);

  @GET('today-progress')
  Future<TodaysProgressData> fetchTodaysProgress(CancelToken cancelToken);

  // week one training
  @GET('week-one-training-contents')
  Future<WeekOneTraningWrapperData> fetchWeekOneTraningSet();

  @PATCH('week-one-training')
  Future<WeekOneTraningStatData> updateWeekOneTrainingViewState(
      @Field('week_one_training_day_progress') int currentDay);

  @POST('week-one-training/closed')
  Future<ApiSuccessMessageResponse> closeWeekOneTrainingView();

  @GET('week-one-training')
  Future<WeekOneTraningStatData> fetchWeekOneTraningStats(
      CancelToken cancelToken);

  // flask
  @GET('devices')
  Future<FlaskWrapperData> fetchFlasks(@Query('offset') int offset,
      @Query('perPage') int perPage, CancelToken fetchFlasksCancelToken);

  @POST('devices')
  Future<FlaskData> addNewFlask(@Field('serial_id') String identifier,
      @Field('name') String name, CancelToken addFlaskCancelToken);

  @PATCH('devices/{id}')
  Future<FlaskData> updateFlask(
      @Path('id') String id,
      @Field() String name,
      @Field('led_color') int ledColorId,
      @Field('led_light_mode') bool ledLightMode,
      @Field('volume') double volume,
      @Field('sleep_timer') int wakeUpFromSleepTime,
      @Field('ble_version') String? bleVersion,
      @Field('mcu_version') String? mcuVersion,
      @CancelRequest() CancelToken cancelToken);

  @GET('/device/personalization_options')
  Future<DevicePersonalizationSettingsData> fetchFlaskPersonalizationOptions();

  @POST('/device/firmware_update_log')
  Future<EmptySuccessResponse> updateFirmwareLog(
    @Field('flask_serial_id') String flaskSerialId,
    @Field('completion_type') String completionType,
  );

  @POST('/sync-flask-cycle-data')
  Future<EmptySuccessResponse> uploadBLELog(
    @Field('flask_id') String flaskId,
    @Field('data') List<Map<String, dynamic>> bleLog,
  );

  //protocol
  @GET('protocol_categories')
  Future<ProtocolCategoryWrapperData> fetchProtocolCategories(
      CancelToken cancelToken);

  @GET('protocols')
  Future<ProtocolWrapperData> fetchProtocols(
      {@Query('offset') int? offset,
      @Query('perPage') int? perPage,
      @Query('type') String? type,
      @Query('category') String? category,
      CancelToken? cancelToken});

  @GET('user-protocols')
  Future<ProtocolWrapperData> fetchCustomProtocols(
      {@Query('offset') int? offset,
      @Query('perPage') int? perPage,
      CancelToken? cancelToken});

  @GET('protocols/{id}')
  Future<ProtocolDetailsData> fetchProtocolDetails(
      @Path('id') String id, CancelToken cancelToken);

  @GET('user-protocols/{id}')
  Future<ProtocolDetailsData> fetchCustomProtocolDetails(
      @Path('id') String id, CancelToken cancelToken);

  @POST('protocols/{id}/customize')
  Future<CustomizeProtocolModel> fetchCustomizeProtocolData(
      @Path('id') String id, CancelToken cancelToken);

  @PATCH('user-protocols/{id}')
  Future<CustomizeProtocolModel> saveCustomProtocol(@Path('id') String id,
      @Body() CustomizeProtocolRequestModel customizeProtocolModel);

  @POST('user-protocols')
  Future<CustomizeProtocolModel> createCustomProtocol(@Path('id') String id,
      @Body() CustomizeProtocolRequestModel customizeProtocolModel);

  @POST('protocols/activate')
  Future<ProtocolDetailsData> updateProtocolGoal(
      @Body()
      CustomizeProtocolActiveRequestModel customizeProtocolActiveRequestModel);

  @DELETE('user-protocols/{id}')
  Future<ApiSuccessMessageResponse> deleteUserProtocol(@Path('id') String id);

  @POST('update-water-consumption')
  Future<ApiSuccessMessageResponse> addWaterConsumption(
    @Field('water_amount') int volume,
  );

  @GET('device/version')
  Future<FlaskFirmwareVersionData> fetchFlaskVersion(
      @Query('flask_id') String flaskId,
      @Query('mcu_version') double? mcuVersion,
      @Query('ble_version') String? bleVersion);

  @GET('system-access')
  Future<SystemAccessInfoData> getSystemAccessState();

  @PATCH('/account-profile')
  Future<UserData> updateProfileImage(
    @Part(name: 'image', contentType: 'image/jpeg') File profilePicture,
  );

  @MultiPart()
  @POST('devices/ble-log')
  Future<EmptySuccessResponse> addNewLog(
    @Part(name: 'flask_serial_id') String? flaskSerialId,
    @Part(name: 'has_error') bool hasError,
    @Part(name: 'log_file', contentType: 'multipart/form-data') File file,
  );
}
