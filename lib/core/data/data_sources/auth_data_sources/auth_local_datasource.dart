import 'package:echowater/core/domain/entities/refresh_token_entity.dart';

import '../../../api/exceptions/custom_exception.dart';
import '../../../domain/entities/oauth_token_entity.dart';
import '../../../services/local_storage_service/local_storage_service.dart';

abstract class AuthLocalDataSource {
  Future<OauthTokenEntity> getLastToken();
  Future<void> cacheToken(OauthTokenEntity loginEntity);
  Future<void> updateAccessToken(RefreshTokenEntity tokenEntity);
  Future<void> logout();
}

class AuthLocalDataSourceImpl extends AuthLocalDataSource {
  AuthLocalDataSourceImpl({
    required LocalStorageService localStorageService,
  }) : _localStorageService = localStorageService;
  final LocalStorageService _localStorageService;

  @override
  Future<void> cacheToken(OauthTokenEntity loginEntity) async {
    await _localStorageService.setAccessToken(loginEntity.accessToken);
    await _localStorageService.setUserId(loginEntity.userId);
    return _localStorageService.setRefreshToken(loginEntity.refreshToken);
  }

  @override
  Future<OauthTokenEntity> getLastToken() async {
    final accessToken = await _localStorageService.accessToken;
    final refreshToken = await _localStorageService.refreshToken;
    final userId = await _localStorageService.userId;
    if (accessToken == null || refreshToken == null || userId == null) {
      throw CustomException.noRecords();
    }
    return Future.value(OauthTokenEntity(
        refreshToken: refreshToken, accessToken: accessToken, userId: userId));
  }

  @override
  Future<void> logout() async {
    await _localStorageService.setAccessToken(null);
    await _localStorageService.setRefreshToken(null);
    await _localStorageService.setAccessTokenDuration(null);
    await _localStorageService.setRefreshTokenDuration(null);
    await _localStorageService.setDeviceId(null);
    await _localStorageService.setUserId(null);
    return _localStorageService.setRefreshToken(null);
  }

  @override
  Future<void> updateAccessToken(RefreshTokenEntity tokenEntity) async {
    await _localStorageService.setAccessToken(tokenEntity.accessToken);
  }
}
