import 'dart:io';

import 'package:dio/dio.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:flutter/foundation.dart';

import 'custom_exception.dart';

class ExceptionHandler {
  ExceptionHandler._();

  static CustomException handleException(Object obj) {
    if (obj is DioException) {
      if (kDebugMode) {
        print('${obj.requestOptions.headers}');
      }
      return _getException(obj);
    } else if (obj is CustomException) {
      return obj;
    }
    return CustomException.error('Error');
  }

  static CustomException _getException(DioException error) {
    if (error.type == DioExceptionType.unknown) {
      if (error.error is SocketException) {
        return CustomException.noInternetConnection();
      } else {
        return CustomException.error('Something went wrong');
      }
    } else if (error.type == DioExceptionType.badResponse) {
      try {
        if (error.response!.statusCode == 401) {
          if (error.requestOptions.path.contains('login')) {
            return CustomException.error('check_login_credetials'.localized);
          }
          return CustomException.sessionExpired();
        } else if (error.response!.statusCode == 403) {
          if (error.requestOptions.path.contains('login')) {
            return CustomException.emailNotVerified();
          }
          return fromJson(error.response!.data);
        } else if (error.response!.statusCode == 400 &&
            error.requestOptions.path.contains('login')) {
          return CustomException.error('check_login_credetials'.localized);
        } else if (error.response!.statusCode == 422 &&
            error.requestOptions.path.contains('forgot-password')) {
          return CustomException.error(
              'password_retrieval_email_message'.localized);
        } else {
          return fromJson(error.response!.data);
        }
      } catch (e) {
        return CustomException.error(e.toString());
      }
    } else if (error.type == DioExceptionType.sendTimeout) {
      return CustomException.timeoutExpection();
    } else {
      return CustomException.error(error.message ?? 'Error');
    }
  }

  static CustomException fromJson(Map<String, dynamic> json) {
    final keys = json.keys;
    final messages = <String>[];
    for (final element in keys) {
      if (json[element] is String) {
        messages.add(json[element]);
      } else if (json[element] is List) {
        messages.addAll((json[element] as List).map((item) => item as String));
      }
    }
    return CustomException.error(messages.join('\n'));
  }
}
