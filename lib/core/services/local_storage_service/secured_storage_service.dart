import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'local_storage_service.dart';

class SecuredStorageService implements LocalStorageService {
  SecuredStorageService() {
    init();
  }

  late final FlutterSecureStorage _pref;

  @override
  String accessTokenKey = 'accessTokenKey';

  @override
  String refreshTokenKey = 'refreshTokenKey';

  @override
  String deviceIdKey = 'deviceIdKey';

  @override
  String accessTokenDurationKey = 'accessTokenDurationKey';

  @override
  String refreshTokenDurationKey = 'refreshTokenDurationKey';

  @override
  String userIdKey = 'userIdKey';

  @override
  Future<String?> get accessToken => _pref.read(key: accessTokenKey);

  @override
  Future<String?> getValue({required String key}) {
    return _pref.read(key: key);
  }

  @override
  FutureOr<void> init() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    _pref = const FlutterSecureStorage();
    if (sharedPrefs.getBool('is_first_app_launch') ?? true) {
      await _pref.deleteAll();
      await sharedPrefs.setBool('is_first_app_launch', false);
    }
  }

  @override
  Future<String?> get refreshToken => _pref.read(key: refreshTokenKey);

  @override
  Future<void> setAccessToken(String? accessToken) async {
    return _pref.write(key: accessTokenKey, value: accessToken);
  }

  @override
  Future<void> setRefreshToken(String? refreshToken) async {
    return _pref.write(key: refreshTokenKey, value: refreshToken);
  }

  @override
  Future<void> setValue({required String key, required value}) async {
    await _pref.write(key: key, value: value);
  }

  @override
  Future<void> clearLocalCache() async {
    await setAccessToken(null);
    await setRefreshToken(null);
    await setDeviceId(null);
    return Future.value();
  }

  @override
  Future<String?> get deviceId => _pref.read(key: deviceIdKey);

  @override
  Future<void> setDeviceId(String? deviceId) {
    return _pref.write(key: deviceIdKey, value: deviceId);
  }

  @override
  Future<String?> get accessTokenDuration =>
      _pref.read(key: accessTokenDurationKey);

  @override
  Future<String?> get refreshTokenDuration =>
      _pref.read(key: refreshTokenDurationKey);

  @override
  Future<void> setAccessTokenDuration(String? accessTokenDuration) async {
    return _pref.write(key: accessTokenDurationKey, value: accessTokenDuration);
  }

  @override
  Future<void> setRefreshTokenDuration(String? refreshTokenDuration) async {
    return _pref.write(
        key: refreshTokenDurationKey, value: refreshTokenDuration);
  }

  @override
  Future<void> setUserId(String? userId) async {
    return _pref.write(key: userIdKey, value: userId);
  }

  @override
  Future<String?> get userId => _pref.read(key: userIdKey);
}
