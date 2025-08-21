import 'dart:async';
import 'dart:io';

import 'package:crclib/catalog.dart';
import 'package:echowater/core/domain/domain_models/notification_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'util.dart';

class BleUtil {
  factory BleUtil.getInstance() {
    return _instance;
  }
  BleUtil._internal();
  static final BleUtil _instance = BleUtil._internal();

  List<Guid> serverUuidList = [
    Guid('6e400001-b5a3-f393-e0a9-e50e24dcca9e'),
    Guid('65010001-1d0f-47d7-b149-c2fdf0006916')
  ];
  List<Guid> writeUuidList = [
    Guid('6e400002-b5a3-f393-e0a9-e50e24dcca9e'),
    Guid('65010002-1d0f-47d7-b149-c2fdf0006916')
  ];
  List<Guid> notifyUuidList = [
    Guid('6e400003-b5a3-f393-e0a9-e50e24dcca9e'),
    Guid('65010003-1d0f-47d7-b149-c2fdf0006916')
  ];
  Guid SERUUID_180A = Guid('180a');
  Guid READUUID_2A29 = Guid('2a29');

  BluetoothDevice? device;
  BluetoothCharacteristic? writeCharacteristics;

  OnUint8ListListener? _uint8listListener;
  StreamSubscription<List<int>>? _notifyListener;
  StreamSubscription<List<ScanResult>>? _scanResListener;
  StreamSubscription<BluetoothConnectionState>? _deviceStateListener;
  OnListener? _listener;
  StreamSubscription<BluetoothAdapterState>? _bluetoothAdapterListener;

  int retryCount = 0;
  Timer writeTimer = Timer(Duration.zero, () => {});
  BluetoothAdapterState? bluetoothAdapterState;

  Future<void> checkBleState(BuildContext context, OnListener listener) async {
    _listener = listener;
    if (await FlutterBluePlus.isSupported == false) {
      showToast(context, 'This device does not support Bluetooth');
      return;
    }
    await _bluetoothAdapterListener?.cancel();

    if (bluetoothAdapterState == null) {
      _bluetoothAdapterListener = FlutterBluePlus.adapterState.listen((state) {
        bluetoothAdapterState = state;
        _checkBle(context, _listener);
      });
    } else {
      await _checkBle(context, _listener);
    }
  }

  Future<void> _checkBle(BuildContext context, OnListener? listener) async {
    if (bluetoothAdapterState == BluetoothAdapterState.on) {
      listener?.call();
    } else {
      showToast(context, 'please open bluetooth');
      if (Platform.isAndroid) {
        await FlutterBluePlus.turnOn();
      }
    }
  }

  void dispose() {
    // Cancel all active listeners

    _listener = null;

    _bluetoothAdapterListener?.cancel();
    _bluetoothAdapterListener = null;

    _notifyListener?.cancel();
    _notifyListener = null;

    _scanResListener?.cancel();
    _scanResListener = null;

    _deviceStateListener?.cancel();
    _deviceStateListener = null;
    bluetoothAdapterState = null;

    // Cancel any pending timers
    writeTimer.cancel();

    // Disconnect from device if connected
    disconnect();

    // Reset variables
    device = null;
    writeCharacteristics = null;
    _uint8listListener = null;
    retryCount = 0;
  }

  Future startScan({required OnScanResultListener listener}) async {
    await FlutterBluePlus.stopScan();
    if (_scanResListener != null) {
      await _scanResListener?.cancel();
    }
    _scanResListener = FlutterBluePlus.onScanResults.listen(
      (results) {
        if (results.isNotEmpty) {
          final r = results.last; // the most recently found device
          if (!isEmpty(r.device.advName)) {
            listener(r);
          }
        }
      },
      onError: (e) => {Util.v(e, tag: 'ScanError')},
    );
    FlutterBluePlus.cancelWhenScanComplete(_scanResListener!);
    Util.v('scan start');
    await FlutterBluePlus.startScan(
        timeout: const Duration(seconds: 10), androidUsesFineLocation: true);
    await FlutterBluePlus.isScanning.where((val) => val == false).first;
    Util.v('scan stop');
  }

  Future<void> stopScan() async {
    await FlutterBluePlus.stopScan();
  }

  Future<void> connect(BuildContext context, BluetoothDevice device,
      OnBoolListener listener) async {
    this.device = device;
    await device.disconnect();
    try {
      await device.connect(timeout: const Duration(seconds: 15));
    } catch (e) {
      listener(false);
      return;
    }
    if (_deviceStateListener != null) {
      await _deviceStateListener!.cancel();
    }
    _deviceStateListener = device.connectionState.listen((state) async {
      if (state == BluetoothConnectionState.disconnected) {
      } else if (state == BluetoothConnectionState.connected) {
        await notify(context, listener);
      }
    });
    device.cancelWhenDisconnected(_deviceStateListener!,
        delayed: true, next: true);
  }

  Future disconnect() async {
    if (device != null) {
      await device?.disconnect();
    }
  }

  Future<void> notify(BuildContext context, OnBoolListener listener) async {
    //打开监听
    try {
      final services = await device!.discoverServices();
      final service180a =
          services.firstWhereOrNull((element) => element.uuid == SERUUID_180A);
      if (service180a == null) {
        showToast(context, 'No manufacturer service found');
        listener(false);
        return;
      }
      final read_2a29 = service180a.characteristics
          .firstWhereOrNull((element) => element.uuid == READUUID_2A29);
      if (read_2a29 == null) {
        showToast(context, 'No production features found');
        listener(false);
        return;
      }
      final proName = String.fromCharCodes(await read_2a29.read());
      Util.v(
          "proName: $proName  ${proName == "SHENZHEN RF CRAZY TECHNOLOGY CO., LTD."}");
      if (proName != 'SHENZHEN RF CRAZY TECHNOLOGY CO., LTD.') {
        showToast(context, 'Device manufacturer error');
        listener(false);
        return;
      }
      final service = services
          .firstWhereOrNull((element) => serverUuidList.contains(element.uuid));
      if (service == null) {
        showToast(context, 'No corresponding service found');
        listener(false);
        return;
      }
      writeCharacteristics = service.characteristics
          .firstWhereOrNull((element) => writeUuidList.contains(element.uuid));
      final read = service.characteristics
          .firstWhereOrNull((element) => notifyUuidList.contains(element.uuid));
      if (writeCharacteristics == null || read == null) {
        showToast(context, 'No corresponding features found');
        listener(false);
        return;
      }
      if (_notifyListener != null) {
        await _notifyListener?.cancel();
      }
      await read.setNotifyValue(true);
      _notifyListener = read.lastValueStream.listen((buffer) {
        if (buffer.isNotEmpty && _uint8listListener != null) {
          Util.v('Log: ${Util.getHexString(buffer)}  length：${buffer.length}');
          writeTimer.cancel();
          _uint8listListener!(Uint8List.fromList(buffer));
        }
      });
      Util.v('Monitoring successful：${writeCharacteristics?.uuid.toString()}');
      listener(true);
    } catch (e) {
      showToast(context, 'Monitoring failed');
      listener(false);
    }
  }

  void writeTry(Uint8List data, OnUint8ListListener listener, int delayS) {
    retryCount = 0;
    writeTimer.cancel();
    _writeAttempts(data, listener, delayS);
  }

  // retry count
  void _writeAttempts(
      Uint8List data, OnUint8ListListener listener, int delayS) {
    write(data, (res) {
      if (res.isNotEmpty) {
        listener(res);
      } else {
        retryCount++;
        if (retryCount > 3) {
          listener(Uint8List(0));
        } else {
          _writeAttempts(data, listener, delayS);
        }
      }
    }, delayS);
  }

  void write(Uint8List data, OnUint8ListListener listener, int delayS) {
    Util.v('Send data： ${Util.getHexString(data)}  length：${data.length}');
    writeTimer = Timer(Duration(seconds: delayS), () {
      listener(Uint8List(0));
    });
    _uint8listListener = listener;
    writeCharacteristics?.write(data,
        withoutResponse: writeCharacteristics!.properties.writeWithoutResponse);
  }

  Future<Uint8List> writeWait(Uint8List block, delayS) {
    final completer = Completer<Uint8List>();
    write(block, (data) {
      if (!completer.isCompleted) {
        completer.complete(data);
      }
    }, delayS);
    return completer.future;
  }

  Future<Uint8List> sendBlock(Uint8List block, delayS) {
    final completer = Completer<Uint8List>();
    writeTry(block, (data) {
      if (!completer.isCompleted) {
        completer.complete(data);
      }
    }, delayS);
    return completer.future;
  }

  Uint8List getBlockCmd(Uint8List block, bool isMcu, Uint8List address,
      int blockCount, int blockNum) {
    final data = Uint8List(block.length + address.length + 9);
    var index = 0;
    data[index++] = isMcu ? 0xAB : 0xBA;
    for (var i = 0; i < address.length; i++) {
      data[index++] = address[i];
    }
    data[index++] = (blockCount >> 8) & 0xFF;
    data[index++] = blockCount & 0xFF;
    data[index++] = (blockNum >> 8) & 0xFF;
    data[index++] = blockNum & 0xFF;
    data[index++] = block.length & 0xFF;
    for (var i = 0; i < block.length; i++) {
      data[index++] = block[i];
    }
    final crcData = data.sublist(0, index);
    final crc = Crc16Ccitt().convert(crcData).toBigInt().toInt();
    data[index++] = (crc >> 8) & 0xFF;
    data[index++] = crc & 0xFF;
    data[index] = isMcu ? 0x54 : 0x45;
    return data;
  }
}

BleUtil bleUtil = BleUtil.getInstance();
