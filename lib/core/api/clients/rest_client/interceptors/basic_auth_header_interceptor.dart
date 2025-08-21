import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../../base/utils/utilities.dart';

class BasicAuthHeaderInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers.addAll(_getBasicAuthHeader());
    handler.next(options);
  }

  static Map<String, String> _getBasicAuthHeader() {
    final username = Utilities.isAndroid()
        ? dotenv.env['BASIC_AUTH_USERNAME_ANDROID']!
        : dotenv.env['BASIC_AUTH_USERNAME_IOS']!;
    final password = Utilities.isAndroid()
        ? dotenv.env['BASIC_AUTH_PASSWORD_ANDROID']!
        : dotenv.env['BASIC_AUTH_PASSWORD_IOS']!;
    final basicAuthValue =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';
    return {'Authorization': basicAuthValue};
  }
}
