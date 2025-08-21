import 'package:dio/dio.dart';

import '../../../../../base/utils/utilities.dart';
import '../../../../data/data_sources/auth_data_sources/auth_local_datasource.dart';

class BearerTokenInterceptor extends Interceptor {
  BearerTokenInterceptor({required AuthLocalDataSource localDataSource})
      : _authLocalDataSource = localDataSource;

  final AuthLocalDataSource _authLocalDataSource;

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      final bearerToken = await _authLocalDataSource.getLastToken();
      options.headers['Authorization'] = 'Bearer ${bearerToken.accessToken}';
      handler.next(options);
    } catch (e) {
      Utilities.printObj(e);
    }
  }
}
