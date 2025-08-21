import 'package:flutter_blue_plus/flutter_blue_plus.dart';

enum BLEDeviceState {
  connected,
  disconnected;

  String get title {
    switch (this) {
      case BLEDeviceState.connected:
        return 'Disconnect';
      case BLEDeviceState.disconnected:
        return 'Connect';
    }
  }
}

class AppBleModel {
  AppBleModel(
      {required this.identifier,
      required this.bleDevice,
      required this.state,
      required this.rssi});
  String identifier;
  String get aliasIdentifier => identifier;
  BluetoothDevice bleDevice;
  BLEDeviceState state;
  int rssi;
}
