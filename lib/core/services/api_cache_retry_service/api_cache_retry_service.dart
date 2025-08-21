import 'package:echowater/core/domain/repositories/flask_repository.dart';
import 'package:echowater/core/injector/injector.dart';

enum CacheReason {
  noInternetConnection,
  apiError;
}

class ApiCacheRetryService {
  ApiCacheRetryService();

  FlaskRepository? _flaskRepository;

  List<Map<String, dynamic>> cycleRunLogs = [];

  void instantiate() {
    _flaskRepository = Injector.instance<FlaskRepository>();
  }

  void addCacheStartCycle(
      {required String flaskId,
      required double? ppmGenerated,
      required CacheReason cacheReason}) {
    /*
 {
        'date': logDate.toIso8601String(),
        'flasks': totalFlask,
        'ppm': ppmGenerated.toString()
      };
        */
  }
}
