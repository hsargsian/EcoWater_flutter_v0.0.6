import 'dart:async';

abstract class LocalStorageService {
  String refreshTokenKey = '';
  String refreshTokenDurationKey = '';
  String accessTokenDurationKey = '';

  String deviceIdKey = '';

  String userIdKey = '';
  String accessTokenKey = '';

  FutureOr<void> init();

  Future<String?> get refreshToken;
  Future<String?> get refreshTokenDuration;
  Future<String?> get accessTokenDuration;
  Future<String?> get deviceId;

  Future<String?> get accessToken;
  Future<String?> get userId;

  Future<void> setRefreshToken(String? refreshToken);
  Future<void> setAccessTokenDuration(String? accessTokenDuration);
  Future<void> setRefreshTokenDuration(String? refreshTokenDuration);
  Future<void> setDeviceId(String? deviceId);

  Future<void> setAccessToken(String? accessToken);
  Future<void> setUserId(String? userId);
  Future<void> clearLocalCache();

  void setValue({required String key, required dynamic value});
  dynamic getValue({required String key});
}
