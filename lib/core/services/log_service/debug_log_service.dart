import 'package:logger/logger.dart';
import 'log_service.dart';

class DebugLogService implements LogService {
  DebugLogService({Logger? logger}) {
    _logger = logger ??
        Logger(
          printer: PrettyPrinter(),
        );
  }
  late final Logger _logger;

  @override
  void e(String message, dynamic e, StackTrace? stack) {
    _logger.e(message, error: e, stackTrace: stack);
  }
}
