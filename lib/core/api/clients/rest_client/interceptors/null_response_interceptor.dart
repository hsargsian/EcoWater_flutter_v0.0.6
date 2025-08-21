import 'package:dio/dio.dart';

class NullResponseInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.statusCode == 200 && response.data == '') {
      response.data = <String, dynamic>{};
    } else if (response.statusCode == 201 && response.data == '') {
      response.data = <String, dynamic>{};
    } else if (response.statusCode == 204 && response.data == '') {
      response.data = <String, dynamic>{};
    } else if (response.statusCode == 409 &&
        response.requestOptions.path == 'users') {
      response.data = <String, dynamic>{
        'error': 'Email address already registered'
      };
    }
    handler.next(response);
  }
}
