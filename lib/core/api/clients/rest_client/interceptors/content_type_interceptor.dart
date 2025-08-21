import 'package:dio/dio.dart';

class ContentTypeInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Content-Type'] = 'application/json';
    handler.next(options);
  }
}
