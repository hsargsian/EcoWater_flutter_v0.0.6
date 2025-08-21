import 'package:dio/dio.dart';

import '../../../../data/data_sources/auth_data_sources/auth_local_datasource.dart';
import '../../../../data/data_sources/auth_data_sources/auth_remote_datasource.dart';
import '../../../../injector/injector.dart';

class RefreshTokenInterceptor extends Interceptor {
  RefreshTokenInterceptor(
      {required AuthRemoteDataSource remoteDataSource,
      required AuthLocalDataSource localDataSource})
      : _authRemoteDataSource = remoteDataSource,
        _authLocalDataSource = localDataSource;

  final AuthRemoteDataSource _authRemoteDataSource;
  final AuthLocalDataSource _authLocalDataSource;

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final tokenRefreshed = await _refreshAccessToken();
      if (tokenRefreshed) {
        handler.resolve(await _retry(err.requestOptions));
        return;
      }
    }

    handler.next(err);
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options =
        Options(method: requestOptions.method, headers: requestOptions.headers);
    final dio = Injector.instance.get<Dio>(instanceName: 'authorizedInstance');
    final response = await dio.request<dynamic>(requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options);
    return response;
  }

  Future<bool> _refreshAccessToken() async {
    try {
      final refreshTokenEntity = await _authLocalDataSource.getLastToken();
      final refreshResponse = await _authRemoteDataSource
          .refreshToken(refreshTokenEntity.refreshToken);
      final tokenEntity = refreshResponse.asEntity();
      await _authLocalDataSource.updateAccessToken(tokenEntity);
      return true;
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 401) {
        await _authLocalDataSource.logout();
        return false;
      }
      return false;
    }
  }
}
