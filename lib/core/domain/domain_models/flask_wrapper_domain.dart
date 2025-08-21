import 'package:echowater/core/domain/domain_models/flask_domain.dart';
import 'package:echowater/oc_libraries/ble_service/ble_manager.dart';

class FlaskWrapperDomain {
  FlaskWrapperDomain(this.hasMore, this.flasks);
  bool hasMore;
  List<FlaskDomain> flasks;

  void remove({required FlaskDomain flask}) {
    flasks.remove(flask);
  }

  List<String> get flaskIds => flasks.map((item) => item.serialId).toList();

  void updateFlask({required FlaskDomain flask}) {
    final index = flasks.indexOf(flask);
    if (index != -1) {
      flasks[index] = flask;
    }
  }

  void updateBLEModel() {
    final managers = BleManager().connectedDevices;
    for (final flask in flasks) {
      if (managers.containsKey(flask.serialId)) {
        flask.appBleModelDevice = managers[flask.serialId]?.appBleDevice;
      } else {
        flask.appBleModelDevice = null;
      }
    }
  }
}
