import 'package:dio/dio.dart';

import '../../../../../base/utils/utilities.dart';

class SchemaNameInterceptor extends Interceptor {
  SchemaNameInterceptor();

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      options.headers['X-Schema-Name'] = 'echowater';
      // options.headers['X-Schema-Name'] = 'wise-imp-kind';
      handler.next(options);
      Utilities.printObj(options.headers);
    } catch (e) {
      Utilities.printObj(e);
    }
  }
}
