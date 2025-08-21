// ignore_for_file: unnecessary_string_interpolations

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../flavor_config.dart';
import '../api/clients/rest_client/auth_api_client/auth_api_client.dart';
import '../api/clients/rest_client/authorized_api_client/authorized_api_client.dart';
import '../api/clients/rest_client/interceptors/app_header_interceptor.dart';
import '../api/clients/rest_client/interceptors/bearer_token_interceptor.dart';
import '../api/clients/rest_client/interceptors/content_type_interceptor.dart';
import '../api/clients/rest_client/interceptors/null_response_interceptor.dart';
import '../api/clients/rest_client/interceptors/refresh_token_interceptor.dart';
import '../api/clients/rest_client/interceptors/schema_name_interceptor.dart';
import '../services/api_log_service.dart';
import 'injector.dart';

// ignore: cascade_invocations
class RestClientModule {
  RestClientModule._();

  static void init() {
    final injector = Injector.instance;
    const dioInstance = 'dioInstace';

    injector.registerLazySingleton<Dio>(() {
      final basicDio = Dio(BaseOptions(baseUrl: FlavorConfig.baseUrl()));
      basicDio.interceptors.clear();
      //basicDio.interceptors.add(BasicAuthHeaderInterceptor());
      basicDio.interceptors.add(SchemaNameInterceptor());
      basicDio.interceptors.add(AppHeaderInterceptor(injector()));
      basicDio.interceptors.add(NullResponseInterceptor());
      basicDio.interceptors.add(ContentTypeInterceptor());
      if (!kReleaseMode) {
        basicDio.interceptors
            .add(LogInterceptor(requestBody: true, responseBody: true));
        basicDio.interceptors
            .add(Injector.instance<ApiLogService>().aliceInterceptor);
      }
      return basicDio;
    }, instanceName: dioInstance);

    // ignore: cascade_invocations
    injector.registerFactory<AuthApiClient>(
        () => AuthApiClient(injector(instanceName: dioInstance)));

    const authorizedInstance = 'authorizedInstance';
    injector.registerLazySingleton<Dio>(() {
      final dio = Dio(BaseOptions(
        baseUrl: '${FlavorConfig.baseUrl()}',
        // validateStatus: (status) {
        //   return status! >= 200 && status <= 299;
        // },
      ));
      dio.interceptors.clear();
      if (!kReleaseMode) {
        dio.interceptors
            .add(LogInterceptor(requestBody: true, responseBody: true));
        dio.interceptors
            .add(Injector.instance<ApiLogService>().aliceInterceptor);
      }

      dio.interceptors.add(NullResponseInterceptor());
      dio.interceptors.add(ContentTypeInterceptor());
      dio.interceptors.add(AppHeaderInterceptor(injector()));
      dio.interceptors.add(BearerTokenInterceptor(localDataSource: injector()));
      dio.interceptors.add(SchemaNameInterceptor());
      return dio;
    }, instanceName: authorizedInstance);

    // ignore: cascade_invocations
    injector.registerFactory<AuthorizedApiClient>(
        () => AuthorizedApiClient(injector(instanceName: authorizedInstance)));
  }

  static void injectRefreshTokenInterceptor() {
    final injector = Injector.instance;
    final dio = injector.get<Dio>(instanceName: 'authorizedInstance');
    dio.interceptors.add(RefreshTokenInterceptor(
        remoteDataSource: injector(), localDataSource: injector()));
  }
}
