import 'package:echowater/base/utils/utilities.dart';
import 'package:flutter/services.dart';

mixin BluetoothSettings {
  static const platform = MethodChannel('com.echowater/bluetooth');

  static Future<void> openBluetoothSettings() async {
    try {
      await platform.invokeMethod('openBluetoothSettings');
    } on PlatformException catch (e) {
      Utilities.printObj("Failed to open Bluetooth settings: '${e.message}'.");
    }
  }
}
