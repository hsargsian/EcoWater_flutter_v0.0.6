// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authorized_api_client.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers

class _AuthorizedApiClient implements AuthorizedApiClient {
  _AuthorizedApiClient(
    this._dio, {
    this.baseUrl,
  });

  final Dio _dio;

  String? baseUrl;

  @override
  Future<UserData> fetchUserDetail() async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result =
        await _dio.fetch<Map<String, dynamic>>(_setStreamType<UserData>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'account-profile',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = UserData.fromJson(_result.data!);
    return value;
  }

  @override
  Future<UserData> fetchOtherUserDetail(String userId) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result =
        await _dio.fetch<Map<String, dynamic>>(_setStreamType<UserData>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'users/${userId}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = UserData.fromJson(_result.data!);
    return value;
  }

  @override
  Future<ApiSuccessMessageResponse> changePassword(
    String currentPassword,
    String newPassword,
    String confirmPassword,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'old_password': currentPassword,
      'new_password': newPassword,
      'confirm_password': confirmPassword,
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ApiSuccessMessageResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'update-password',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = ApiSuccessMessageResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<UserData> updateUser(
    String firstName,
    String lastName,
    String phoneNumber,
    String countryName,
    String countryCode,
    File? file,
    CancelToken cancelToken,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = {
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
      'country_name': countryName,
      'country_code': countryCode,
    };
    final _result =
        await _dio.fetch<Map<String, dynamic>>(_setStreamType<UserData>(Options(
      method: 'PATCH',
      headers: _headers,
      extra: _extra,
      contentType: 'multipart/form-data',
    )
            .compose(
              _dio.options,
              'account-profile',
              queryParameters: queryParameters,
              data: _data,
              cancelToken: cancelToken,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = UserData.fromJson(_result.data!);
    return value;
  }

  @override
  Future<UserData> updateUserHealthkitIntegration(
    bool isHealthIntegrationEnabled,
    CancelToken cancelToken,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'is_health_integration_enabled': isHealthIntegrationEnabled};
    final _result =
        await _dio.fetch<Map<String, dynamic>>(_setStreamType<UserData>(Options(
      method: 'PATCH',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'account-profile',
              queryParameters: queryParameters,
              data: _data,
              cancelToken: cancelToken,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = UserData.fromJson(_result.data!);
    return value;
  }

  @override
  Future<UserData> updateTheme(
    String id,
    String theme,
    CancelToken cancelToken,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'theme': theme};
    final _result =
        await _dio.fetch<Map<String, dynamic>>(_setStreamType<UserData>(Options(
      method: 'PATCH',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'users/${id}/theme',
              queryParameters: queryParameters,
              data: _data,
              cancelToken: cancelToken,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = UserData.fromJson(_result.data!);
    return value;
  }

  @override
  Future<EmptySuccessResponse> deleteAccount() async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<EmptySuccessResponse>(Options(
      method: 'DELETE',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'users',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = EmptySuccessResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<EmptySuccessResponse> updateDevice(
    String pushToken,
    CancelToken updateDeviceCancelToken,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'token': pushToken};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<EmptySuccessResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'user/set-fcm-token',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = EmptySuccessResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<ApiSuccessMessageResponse> logOut(String refreshToken) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'refresh': refreshToken};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ApiSuccessMessageResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'auth/logout',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = ApiSuccessMessageResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<SettingsData> updateSettings(Map<String, bool> settings) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(settings);
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<SettingsData>(Options(
      method: 'PATCH',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'user/notification-settings',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = SettingsData.fromJson(_result.data!);
    return value;
  }

  @override
  Future<SettingsData> fetchSettings() async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<SettingsData>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'user/notification-settings',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = SettingsData.fromJson(_result.data!);
    return value;
  }

  @override
  Future<WalkThroughProgressData> fetchWalkthroughProgress() async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<WalkThroughProgressData>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'user/walkthrough-progress',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = WalkThroughProgressData.fromJson(_result.data!);
    return value;
  }

  @override
  Future<WalkThroughProgressData> updateWalkthroughProgress(
      Map<String, bool> data) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(data);
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<WalkThroughProgressData>(Options(
      method: 'PATCH',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'user/walkthrough-progress',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = WalkThroughProgressData.fromJson(_result.data!);
    return value;
  }

  @override
  Future<EmptySuccessResponse> removeDevice(String deviceId) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<EmptySuccessResponse>(Options(
      method: 'DELETE',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'pushNotifications/registered_devices/${deviceId}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = EmptySuccessResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<AssetData> uploadAsset(
    String type,
    File file,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.fields.add(MapEntry(
      'type',
      type,
    ));
    _data.files.add(MapEntry(
      'file',
      MultipartFile.fromFileSync(
        file.path,
        filename: file.path.split(Platform.pathSeparator).last,
      ),
    ));
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<AssetData>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'multipart/form-data',
    )
            .compose(
              _dio.options,
              'assets',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = AssetData.fromJson(_result.data!);
    return value;
  }

  @override
  Future<FriendsWrapperData> fetchFriends(
    String? search,
    int offset,
    int perPage,
    CancelToken cancelToken,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'search': search,
      r'offset': offset,
      r'perPage': perPage,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<FriendsWrapperData>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'friends/my',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = FriendsWrapperData.fromJson(_result.data!);
    return value;
  }

  @override
  Future<HttpResponse<dynamic>> sendFriendRequest(
    String friendId,
    CancelToken cancelToken,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'friend_id': friendId};
    final _result =
        await _dio.fetch(_setStreamType<HttpResponse<dynamic>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'friends/request',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<ApiSuccessMessageResponse> updateFriendRequestAction(
    String friendId,
    String action,
    CancelToken cancelToken,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'friend_id': friendId,
      'action': action,
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ApiSuccessMessageResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'friends/request-action',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = ApiSuccessMessageResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<FriendRequestsWrapperData> fetchFriendRequestsReceived(
    String isIgnored,
    int offset,
    int perPage,
    CancelToken cancelToken,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'is_ignored': isIgnored,
      r'offset': offset,
      r'perPage': perPage,
    };
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<FriendRequestsWrapperData>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'friends/request-received',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = FriendRequestsWrapperData.fromJson(_result.data!);
    return value;
  }

  @override
  Future<FriendRequestsWrapperData> fetchFriendRequestsSent(
    int offset,
    int perPage,
    CancelToken cancelToken,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'offset': offset,
      r'perPage': perPage,
    };
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<FriendRequestsWrapperData>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'friends/request-sent',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = FriendRequestsWrapperData.fromJson(_result.data!);
    return value;
  }

  @override
  Future<UserDataWrapper> searchUsers(
    int offset,
    int perPage,
    String searchString,
    String isFriendListSearch,
    CancelToken cancelToken,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'offset': offset,
      r'perPage': perPage,
      r'search': searchString,
      r'is_friend_list_search': isFriendListSearch,
    };
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<UserDataWrapper>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'users',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = UserDataWrapper.fromJson(_result.data!);
    return value;
  }

  @override
  Future<UserData> userDetails(
    String id,
    CancelToken cancelToken,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result =
        await _dio.fetch<Map<String, dynamic>>(_setStreamType<UserData>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'users/${id}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = UserData.fromJson(_result.data!);
    return value;
  }

  @override
  Future<NotificationsDataWrapper> fetchNotifications(
    int offset,
    int perPage,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'offset': offset,
      r'limit': perPage,
    };
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NotificationsDataWrapper>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'notifications',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = NotificationsDataWrapper.fromJson(_result.data!);
    return value;
  }

  @override
  Future<HttpResponse<dynamic>> deleteNotification(String id) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result =
        await _dio.fetch(_setStreamType<HttpResponse<dynamic>>(Options(
      method: 'DELETE',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'notifications/${id}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<NotificationCountData> fetchUnreadNotificationsCount() async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NotificationCountData>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'notifications/unread-count',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = NotificationCountData.fromJson(_result.data!);
    return value;
  }

  @override
  Future<NotificationCountData> readUnReadNotiifications() async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NotificationCountData>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'notifications/read-all',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = NotificationCountData.fromJson(_result.data!);
    return value;
  }

  @override
  Future<FlaskData> toggleDevicePair(
    String id,
    bool isPaired,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'is_paired': isPaired};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<FlaskData>(Options(
      method: 'PATCH',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'ble_device/${id}/pair',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = FlaskData.fromJson(_result.data!);
    return value;
  }

  @override
  Future<HttpResponse<dynamic>> unpairFlask(String id) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result =
        await _dio.fetch(_setStreamType<HttpResponse<dynamic>>(Options(
      method: 'DELETE',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'devices/${id}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<ApiSuccessMessageResponse> cleanFlask(String id) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ApiSuccessMessageResponse>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'devices/${id}/clean',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = ApiSuccessMessageResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<ApiSuccessMessageResponse> startFlaskCycle(
    String id,
    double? ppmGenerated,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = {'ppm_generated': ppmGenerated};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ApiSuccessMessageResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'devices/${id}/start-cycle',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = ApiSuccessMessageResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<LedColorResponseWrapperData> fetchLedColors() async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<LedColorResponseWrapperData>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'led-colors',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = LedColorResponseWrapperData.fromJson(_result.data!);
    return value;
  }

  @override
  Future<LearningUrlsData> fetchBaseLearningUrls() async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<LearningUrlsData>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'support-instructions-urls',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = LearningUrlsData.fromJson(_result.data!);
    return value;
  }

  @override
  Future<VideoLearningLibraryWrapperData> fetchVideoLibrary(
    int offset,
    int perPage,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'offset': offset,
      r'perPage': perPage,
    };
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<VideoLearningLibraryWrapperData>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'learnings/videos',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = VideoLearningLibraryWrapperData.fromJson(_result.data!);
    return value;
  }

  @override
  Future<ArticleLearningLibraryWrapperData> fetchArticleLibrary(
    int offset,
    int perPage,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'offset': offset,
      r'perPage': perPage,
    };
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ArticleLearningLibraryWrapperData>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'learnings/articles',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = ArticleLearningLibraryWrapperData.fromJson(_result.data!);
    return value;
  }

  @override
  Future<SocialGoalWrapperData> fetchSocialGoals(
    String userId,
    String date,
    CancelToken cancelToken,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'date': date};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<SocialGoalWrapperData>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'users/${userId}/social-goals',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = SocialGoalWrapperData.fromJson(_result.data!);
    return value;
  }

  @override
  Future<ApiSuccessMessageResponse> deleteSocialGoal(
    String id,
    CancelToken cancelToken,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ApiSuccessMessageResponse>(Options(
      method: 'DELETE',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'social-goals/${id}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = ApiSuccessMessageResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<ApiSuccessMessageResponse> remindSocialGoal(
    String id,
    String friendId,
    CancelToken cancelToken,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'friend_id': friendId};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ApiSuccessMessageResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'social-goals/${id}/remind',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = ApiSuccessMessageResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<HttpResponse<dynamic>> addSocialGoal(
    String goalType,
    int goalNumber,
    List<String> participants,
    String name,
    CancelToken cancelToken,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'goal_type': goalType,
      'goal_number': goalNumber,
      'participants': participants,
      'name': name,
    };
    final _result =
        await _dio.fetch(_setStreamType<HttpResponse<dynamic>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'social-goals',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<dynamic>> updateSocialGoal(
    String goalId,
    String goalType,
    int goalNumber,
    List<String> participants,
    String name,
    CancelToken cancelToken,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'goal_type': goalType,
      'goal_number': goalNumber,
      'participants': participants,
      'name': name,
    };
    final _result =
        await _dio.fetch(_setStreamType<HttpResponse<dynamic>>(Options(
      method: 'PATCH',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'social-goals/${goalId}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<PersonalGoalWrapperData> fetchPersonalGoals(
    String userId,
    String date,
    CancelToken cancelToken,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'date': date};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<PersonalGoalWrapperData>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'users/${userId}/personal-goals',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = PersonalGoalWrapperData.fromJson(_result.data!);
    return value;
  }

  @override
  Future<ApiSuccessMessageResponse> deletePersonalGoal(
    String id,
    CancelToken cancelToken,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ApiSuccessMessageResponse>(Options(
      method: 'DELETE',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'personal-goals/${id}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = ApiSuccessMessageResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<ApiSuccessMessageResponse> addPersonalGoal(
    String goalType,
    int goalNumber,
    CancelToken cancelToken,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'goal_type': goalType,
      'goal_number': goalNumber,
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ApiSuccessMessageResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'personal-goals',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = ApiSuccessMessageResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<UsageDatesData> fetchUsageDates(
    String startDate,
    String endDate,
    CancelToken cancelToken,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'start_date': startDate,
      r'end_date': endDate,
    };
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<UsageDatesData>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'usage-dates',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = UsageDatesData.fromJson(_result.data!);
    return value;
  }

  @override
  Future<UsageStreakData> fetchUsageStreak(CancelToken cancelToken) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<UsageStreakData>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'dashboard-data',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = UsageStreakData.fromJson(_result.data!);
    return value;
  }

  @override
  Future<List<PersonalGoalGraphData>> fetchPersonalGoalGraphData(
    String startDate,
    String endDate,
    String goalType,
    CancelToken cancelToken,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'start-date': startDate,
      r'end-date': endDate,
      r'goal-type': goalType,
    };
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<PersonalGoalGraphData>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'personal-goal/chart-data',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    var value = _result.data!
        .map((dynamic i) =>
            PersonalGoalGraphData.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<TodaysProgressData> fetchTodaysProgress(
      CancelToken cancelToken) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<TodaysProgressData>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'today-progress',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = TodaysProgressData.fromJson(_result.data!);
    return value;
  }

  @override
  Future<WeekOneTraningWrapperData> fetchWeekOneTraningSet() async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<WeekOneTraningWrapperData>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'week-one-training-contents',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = WeekOneTraningWrapperData.fromJson(_result.data!);
    return value;
  }

  @override
  Future<WeekOneTraningStatData> updateWeekOneTrainingViewState(
      int currentDay) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'week_one_training_day_progress': currentDay};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<WeekOneTraningStatData>(Options(
      method: 'PATCH',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'week-one-training',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = WeekOneTraningStatData.fromJson(_result.data!);
    return value;
  }

  @override
  Future<ApiSuccessMessageResponse> closeWeekOneTrainingView() async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ApiSuccessMessageResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'week-one-training/closed',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = ApiSuccessMessageResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<WeekOneTraningStatData> fetchWeekOneTraningStats(
      CancelToken cancelToken) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<WeekOneTraningStatData>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'week-one-training',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = WeekOneTraningStatData.fromJson(_result.data!);
    return value;
  }

  @override
  Future<FlaskWrapperData> fetchFlasks(
    int offset,
    int perPage,
    CancelToken fetchFlasksCancelToken,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'offset': offset,
      r'perPage': perPage,
    };
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<FlaskWrapperData>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'devices',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = FlaskWrapperData.fromJson(_result.data!);
    return value;
  }

  @override
  Future<FlaskData> addNewFlask(
    String identifier,
    String name,
    CancelToken addFlaskCancelToken,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'serial_id': identifier,
      'name': name,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<FlaskData>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'devices',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = FlaskData.fromJson(_result.data!);
    return value;
  }

  @override
  Future<FlaskData> updateFlask(
    String id,
    String name,
    int ledColorId,
    bool ledLightMode,
    double volume,
    int wakeUpFromSleepTime,
    String? bleVersion,
    String? mcuVersion,
    CancelToken cancelToken,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = {
      'name': name,
      'led_color': ledColorId,
      'led_light_mode': ledLightMode,
      'volume': volume,
      'sleep_timer': wakeUpFromSleepTime,
      'ble_version': bleVersion,
      'mcu_version': mcuVersion,
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<FlaskData>(Options(
      method: 'PATCH',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'devices/${id}',
              queryParameters: queryParameters,
              data: _data,
              cancelToken: cancelToken,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = FlaskData.fromJson(_result.data!);
    return value;
  }

  @override
  Future<DevicePersonalizationSettingsData>
      fetchFlaskPersonalizationOptions() async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<DevicePersonalizationSettingsData>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/device/personalization_options',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = DevicePersonalizationSettingsData.fromJson(_result.data!);
    return value;
  }

  @override
  Future<EmptySuccessResponse> updateFirmwareLog(
    String flaskSerialId,
    String completionType,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'flask_serial_id': flaskSerialId,
      'completion_type': completionType,
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<EmptySuccessResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/device/firmware_update_log',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = EmptySuccessResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<EmptySuccessResponse> uploadBLELog(
    String flaskId,
    List<Map<String, dynamic>> bleLog,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'flask_id': flaskId,
      'data': bleLog,
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<EmptySuccessResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/sync-flask-cycle-data',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = EmptySuccessResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<ProtocolCategoryWrapperData> fetchProtocolCategories(
      CancelToken cancelToken) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ProtocolCategoryWrapperData>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'protocol_categories',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = ProtocolCategoryWrapperData.fromJson(_result.data!);
    return value;
  }

  @override
  Future<ProtocolWrapperData> fetchProtocols({
    int? offset,
    int? perPage,
    String? type,
    String? category,
    CancelToken? cancelToken,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'offset': offset,
      r'perPage': perPage,
      r'type': type,
      r'category': category,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ProtocolWrapperData>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'protocols',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = ProtocolWrapperData.fromJson(_result.data!);
    return value;
  }

  @override
  Future<ProtocolWrapperData> fetchCustomProtocols({
    int? offset,
    int? perPage,
    CancelToken? cancelToken,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'offset': offset,
      r'perPage': perPage,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ProtocolWrapperData>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'user-protocols',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = ProtocolWrapperData.fromJson(_result.data!);
    return value;
  }

  @override
  Future<ProtocolDetailsData> fetchProtocolDetails(
    String id,
    CancelToken cancelToken,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ProtocolDetailsData>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'protocols/${id}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = ProtocolDetailsData.fromJson(_result.data!);
    return value;
  }

  @override
  Future<ProtocolDetailsData> fetchCustomProtocolDetails(
    String id,
    CancelToken cancelToken,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ProtocolDetailsData>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'user-protocols/${id}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = ProtocolDetailsData.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CustomizeProtocolModel> fetchCustomizeProtocolData(
    String id,
    CancelToken cancelToken,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<CustomizeProtocolModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'protocols/${id}/customize',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = CustomizeProtocolModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CustomizeProtocolModel> saveCustomProtocol(
    String id,
    CustomizeProtocolRequestModel customizeProtocolModel,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(customizeProtocolModel.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<CustomizeProtocolModel>(Options(
      method: 'PATCH',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'user-protocols/${id}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = CustomizeProtocolModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CustomizeProtocolModel> createCustomProtocol(
    String id,
    CustomizeProtocolRequestModel customizeProtocolModel,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(customizeProtocolModel.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<CustomizeProtocolModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'user-protocols',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = CustomizeProtocolModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<ProtocolDetailsData> updateProtocolGoal(
      CustomizeProtocolActiveRequestModel
          customizeProtocolActiveRequestModel) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(customizeProtocolActiveRequestModel.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ProtocolDetailsData>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'protocols/activate',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = ProtocolDetailsData.fromJson(_result.data!);
    return value;
  }

  @override
  Future<ApiSuccessMessageResponse> deleteUserProtocol(String id) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ApiSuccessMessageResponse>(Options(
      method: 'DELETE',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'user-protocols/${id}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = ApiSuccessMessageResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<ApiSuccessMessageResponse> addWaterConsumption(int volume) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'water_amount': volume};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ApiSuccessMessageResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'update-water-consumption',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = ApiSuccessMessageResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<FlaskFirmwareVersionData> fetchFlaskVersion(
    String flaskId,
    double? mcuVersion,
    String? bleVersion,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'flask_id': flaskId,
      r'mcu_version': mcuVersion,
      r'ble_version': bleVersion,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<FlaskFirmwareVersionData>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'device/version',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = FlaskFirmwareVersionData.fromJson(_result.data!);
    return value;
  }

  @override
  Future<SystemAccessInfoData> getSystemAccessState() async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<SystemAccessInfoData>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'system-access',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = SystemAccessInfoData.fromJson(_result.data!);
    return value;
  }

  @override
  Future<UserData> updateProfileImage(File profilePicture) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.files.add(MapEntry(
      'image',
      MultipartFile.fromFileSync(
        profilePicture.path,
        filename: profilePicture.path.split(Platform.pathSeparator).last,
        contentType: MediaType.parse('image/jpeg'),
      ),
    ));
    final _result =
        await _dio.fetch<Map<String, dynamic>>(_setStreamType<UserData>(Options(
      method: 'PATCH',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/account-profile',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = UserData.fromJson(_result.data!);
    return value;
  }

  @override
  Future<EmptySuccessResponse> addNewLog(
    String? flaskSerialId,
    bool hasError,
    File file,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    if (flaskSerialId != null) {
      _data.fields.add(MapEntry(
        'flask_serial_id',
        flaskSerialId,
      ));
    }
    _data.fields.add(MapEntry(
      'has_error',
      hasError.toString(),
    ));
    _data.files.add(MapEntry(
      'log_file',
      MultipartFile.fromFileSync(
        file.path,
        filename: file.path.split(Platform.pathSeparator).last,
        contentType: MediaType.parse('multipart/form-data'),
      ),
    ));
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<EmptySuccessResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'multipart/form-data',
    )
            .compose(
              _dio.options,
              'devices/ble-log',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = EmptySuccessResponse.fromJson(_result.data!);
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(
    String dioBaseUrl,
    String? baseUrl,
  ) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}
