// this call behind the hood sits and calls the flasks iteratively and if finds disconnected, tries to connect it
import 'package:echowater/core/domain/domain_models/flask_domain.dart';

class BleConnectorService {
  factory BleConnectorService() {
    return _instance;
  }
  BleConnectorService._internal();

  static final BleConnectorService _instance = BleConnectorService._internal();

  void refresh(List<FlaskDomain> flasks) {}
}
