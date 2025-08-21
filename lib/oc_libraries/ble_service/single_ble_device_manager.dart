import 'dart:async';

import 'package:echowater/base/utils/date_utils.dart';
import 'package:echowater/core/injector/injector.dart';
import 'package:echowater/core/services/api_log_service.dart';
import 'package:echowater/oc_libraries/ble_service/app_ble_model.dart';
import 'package:echowater/oc_libraries/ble_service/ble_constants.dart';
import 'package:echowater/oc_libraries/ble_service/ble_manager.dart';
import 'package:echowater/oc_libraries/ble_service/flask_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../base/utils/utilities.dart';
import '../../core/domain/domain_models/flask_option.dart';
import '../../core/domain/repositories/flask_repository.dart';
import '../../core/services/refresh.dart';
import '../../screens/profile_module/ble_configurator_screen/ble_configurator_screen.dart';

class SingleBLEDeviceManager {
  SingleBLEDeviceManager(this.appBleDevice, this.onStateChanged);

  final AppBleModel appBleDevice;
  final void Function(
          SingleBLEDeviceManager manager, BluetoothConnectionState state)?
      onStateChanged;
  bool _isConnected = false;
  List<BluetoothService> _services = [];
  static const _pref = FlutterSecureStorage();

  StreamSubscription<BluetoothConnectionState>? _connectionstateSubscription;
  String transferCharacteristics = BleConstants.txCharacterUUID;
  String readCharacteristics = BleConstants.rxCharacterUUID;
  FlaskRepository? _flaskRepository;

  String? bleVersion;
  double? mcuVersion;
  bool _hasNotifiedMCU = false;

  Timer writeTimer = Timer(Duration.zero, () => {});
  BluetoothCharacteristic? writeCharacter;
  int retryCount = 0;
  DateTime? _lastFlaskDataRevicedDate;

  bool _isRequestingBatch = false;
  Timer? _timeoutTimer;
  int _timeoutDuration = 8; // Timeout duration in seconds

  StreamSubscription<List<int>>? _valueListenSubscription;

  Map<String, dynamic> _batchLogs = {};

  Future<void> disconnect() async {
    _debugLog('Device disconnected');
    await appBleDevice.bleDevice.disconnect();
    await _connectionstateSubscription?.cancel();
    _isConnected = false;
  }

  bool get isConnected => _isConnected;

  Future<void> _setData() async {
    transferCharacteristics =
        await _pref.read(key: 'txCharUUid') ?? BleConstants.txCharacterUUID;
    readCharacteristics =
        await _pref.read(key: 'rxCharUUid') ?? BleConstants.rxCharacterUUID;
  }

  void dispose() {
    _connectionstateSubscription?.cancel();
    _valueListenSubscription?.cancel();
  }

  Future<void> _discoverServices() async {
    await _setData();
    _debugLog(
        '-----------------------------------------------------------------');
    _debugLog('Initiated Discovering services');
    if (appBleDevice.bleDevice.isDisconnected) {
      _debugLog('Device already disconnected');
      return;
    }
    _services = await appBleDevice.bleDevice.discoverServices();
    _debugLog('Looping through services');
    for (final service in _services) {
      final characteristics = service.characteristics;
      for (final c in characteristics) {
        if (c.properties.notify &&
            c.characteristicUuid == Guid.fromString(readCharacteristics)) {
          _debugLog('Initiated Data Read on Read characteristic');
          unawaited(_readData(appBleDevice.bleDevice, service, c));
        } else {
          if (service.serviceUuid ==
              Guid.fromString(BleConstants.deviceInfoServiceUUID)) {
            if (c.characteristicUuid ==
                Guid.fromString(BleConstants.deviceInfoCharacterUUID)) {
              _debugLog('Initiated Flask version read');
              unawaited(_readFlaskVersionInfo(c));
            }
          }
        }
      }
    }
    _debugLog('Initiated Update Internet Based Time');
    BleManager().updateInternetBasedTime(this);
    await Future.delayed(Duration(milliseconds: throttleSliderValue));
    _debugLog('Initiated Request Batch Data');
    BleManager().requestBatchData(this);
  }

  Future<void> _readFlaskVersionInfo(
      BluetoothCharacteristic characteristic) async {
    try {
      final value = await characteristic.read();
      bleVersion = String.fromCharCodes(value);
      _debugLog('Recognized version $bleVersion');
    } on Exception catch (e) {
      _debugLog('Error Recognizing version $e');
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> _readData(BluetoothDevice device, BluetoothService service,
      BluetoothCharacteristic characteristic) async {
    if (!_isConnected) {
      _debugLog('Trying to initiate read data but flask already disconnected');
      return;
    }
    await _valueListenSubscription?.cancel();
    _debugLog('Cancelled old read subscription if any');
    _valueListenSubscription =
        characteristic.onValueReceived.listen((readValue) {
      _lastFlaskDataRevicedDate = DateTime.now();
      if (readValue.isNotEmpty) {
        _onNewValueReceived(readValue);
        if (readValue.length >= 4) {
          BleManager()
              .onNewLog
              ?.call(readValue, null, false, null, readValue[3] == 0x30);
        }
      }
    });
    device.cancelWhenDisconnected(_valueListenSubscription!);
    await characteristic.setNotifyValue(true);
  }

  void _handleBatchData(List<int> data) {
    if (data.length != 12) {
      return;
    }

    final logDate = data.sublist(4, 8).toDateTime();
    final totalFlask = data[8];
    final totalPPM = (data[9] << 8) | data[10];
    final ppmGenerated = totalPPM / 100;
    final dateString = logDate.humanReadableDateString(
        hasShortHad: false, format: 'yyyy-MM-dd');
    _debugLog('Received a batch info data');
    _debugLog('BatchLog-------------Batch Log------------');
    _debugLog('BatchLog Log Date: $logDate');
    _debugLog('BatchLog Total Flask: $totalFlask');
    _debugLog('BatchLog ppmGenerated: $ppmGenerated');
    _debugLog('BatchLog dateString: $dateString');
    _debugLog('BatchLog -------------------------');

    if (!_isRequestingBatch) {
      _debugLog('As batch data was not being requested, not adding it to logs');
      return;
    }
    // Reset the timeout timer since we received data
    _resetTimeoutTimer();

    if (!_batchLogs.containsKey(dateString)) {
      _debugLog('The date didnt exist in log. Adding it');
      _batchLogs[dateString] = {
        'date': logDate.toIso8601String(),
        'flasks': totalFlask,
        'ppm': ppmGenerated.toString()
      };
    }
  }

  void _setMcuVersion(List<int> data) {
    if (data.length == 13) {
      // still old int version
      mcuVersion = data[11].toDouble();
    } else if (data.length == 14) {
      mcuVersion = data[11] + (data[12] / 10);
    }

    print('~~~~~~~~~~~~ MCU Version: $mcuVersion ~~~~~~~~~~~~~');
    if (!_hasNotifiedMCU) {
      _hasNotifiedMCU = true;
      BleManager().onFlaskMCURead?.call(appBleDevice, mcuVersion);
    }
  }

  void _onNewValueReceived(List<int> data) {
    if (data.isEmpty || data.length < 5) {
      return; // invalid or incomplete packet
    }

    if (data[0] != 0xAA || data[1] != 0x55) {
      return; // invalid header
    }

    // check if its a batch data log data
    if (data[3] == 0x30) {
      _handleBatchData(data);
      return;
    }

    if (_isRequestingBatch) {
      return;
    }

    if (data[3] != 0x20) {
      // not the pulse data command
      return;
    }
    if (data.length < 13) {
      return;
    }

    _setMcuVersion(data);

    final value = data[4]; // this checks if there is active cycle running

    if (data[7] >= 0 && (data[8] >= 1)) {
      // if the time is say 0 minutes or more and 1 second or more, its a active cycle running, so we dont fetch the batch data
      _isRequestingBatch = false;
      _timeoutTimer?.cancel();
    }

    if (value == 0x01) {
      // There is an active cycle running
      final ppmInt = (data[9] << 8) |
          data[
              10]; // 2 byte data, giving the total h2 ppm, ppm are in decimals, say 2.35, but decimal takes 8 bytes, so we use integer value
      final ppmGenerated =
          ppmInt / 100; // divide by 100 to get decimal value of ppm

      if (data[7] == 0x00 && (data[8] == 0x01)) {
        // The timer now is 0 minutes and 1 seconds, after one second
        // it will be 0 min & 0 sec, but data[4] will also be 0 i.e.
        // cycle is not running, so we go to do it now
        _debugLog('New cycle ended with active BLE connection');
        BleManager().cycleRunningFlasks.remove(appBleDevice.identifier);
        BleManager().onCycleRun?.call(appBleDevice, ppmGenerated);
        return;
      } else if (!BleManager()
          .cycleRunningFlasks
          .contains(appBleDevice.identifier)) {
        BleManager().cycleRunningFlasks.add(appBleDevice.identifier);
      }
    } else if (value == 0x00) {
      if (BleManager().cycleRunningFlasks.contains(appBleDevice.identifier)) {
        BleManager().cycleRunningFlasks.remove(appBleDevice.identifier);
      }
    } else if (value == 0x02) {
      // flask is cleaning// not doing aything for this for now
    }
  }

  bool _needsFlaskAwake() {
    if (_lastFlaskDataRevicedDate == null) {
      _debugLog('will wake the flask up');
      return true;
    }
    final flag =
        DateTime.now().difference(_lastFlaskDataRevicedDate!).inSeconds > 3;
    Utilities.bleLog('will ${flag ? '' : 'not'} wake the flask up');
    return flag;
  }

  Future<void> writeData(
      String serviceId, FlaskCommand command, List<int> data) async {
    var serviceFound = false;
    var characteristicsFound = false;
    for (final service in _services) {
      if (service.uuid.toString().toLowerCase() == serviceId.toLowerCase()) {
        serviceFound = true;
        for (final char in service.characteristics) {
          if (char.uuid.toString().toLowerCase() ==
              transferCharacteristics.toLowerCase()) {
            characteristicsFound = true;
            writeCharacter = char;
            if (_needsFlaskAwake()) {
              await write(writeCharacter, FlaskCommand.wakeUp.commandData);
              await Future.delayed(Duration(milliseconds: throttleSliderValue));
            }
            await write(
              writeCharacter,
              data,
            );
            BleManager().onNewLog?.call(data, command.name, true,
                'Sending command was successful', false);
            return;
          }
        }
      }
    }
    BleManager().onNewLog?.call(
        data,
        command.name,
        true,
        'Error sending command, Service Found: ${serviceFound ? 'true' : 'false'}, Characteristic found:  ${characteristicsFound ? 'true' : 'false'}',
        false);
  }

  Future<void> write(
      BluetoothCharacteristic? writeCharacter, List<int> value) async {
    var retryCount = 0;
    const maxRetries = 3;

    while (retryCount <= maxRetries) {
      try {
        await writeCharacter?.write(value);
        return;
      } on Exception catch (e) {
        if (kDebugMode) {
          print(e);
        }

        retryCount++;

        if (retryCount > maxRetries) {
          // insepct on why write was not successful? may be the flask is disconnected and we need to reconnect
          return;
        }

        // Optional: Add a delay before retrying
        await Future.delayed(Duration(milliseconds: 100 * retryCount));
      }
    }
  }

  Stream<List<int>> readData(BluetoothDevice device, String serviceUUID,
      String characteristicUUID) async* {
    final characteristic = _services
        .firstWhere((service) =>
            service.uuid.toString().toLowerCase() == serviceUUID.toLowerCase())
        .characteristics
        .firstWhere((characteristic) =>
            characteristic.uuid.toString() == characteristicUUID);

    yield* characteristic.lastValueStream;
  }

  Future<void> connect(bool isAlreadyConnected) async {
    var needsCallback = false;
    await _connectionstateSubscription?.cancel();
    _connectionstateSubscription =
        appBleDevice.bleDevice.connectionState.listen((state) async {
      try {
        if (state == BluetoothConnectionState.connected) {
          needsCallback = true;
          _isConnected = true;
          _lastFlaskDataRevicedDate = DateTime.now();
          unawaited(_discoverServices());
        } else if (state == BluetoothConnectionState.disconnected) {
          if (kDebugMode) {
            print('ashwinecho: Device disconnected');
          }
          if (_isConnected) {
            needsCallback = true;
          }
          _isConnected = false;
        }
        appBleDevice.state = state == BluetoothConnectionState.connected
            ? BLEDeviceState.connected
            : BLEDeviceState.disconnected;
        if (needsCallback) {
          onStateChanged?.call(this, state);
        }
        needsCallback = true;
      } on Exception catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    });
    if (!isAlreadyConnected) {
      try {
        await appBleDevice.bleDevice
            .connect(timeout: const Duration(seconds: 60));
      } on Exception catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }
  }

  void clearDataLog(String serviceId) {
    _debugLog('Initiating clear data log');
    writeData(serviceId, FlaskCommand.clearDataLog,
        FlaskCommand.clearDataLog.commandData.addingCRC());
    _debugLog('Data log cleared');
  }

  Future<void> requestBatchData(String serviceId) async {
    // we were asked to have start date greater than jan 1st, to be safe with utc conversions we have on 5th of jan 2025
    if (_isRequestingBatch) {
      return;
    }
    _debugLog('Requesting data log');
    BleManager().onDataLogRequestChange?.call('Syncing your data...', true);
    _isRequestingBatch = true;
    _batchLogs = {};
    final startDateAndTime = await FlaskManager()
        .getFlaskQueryStartDate(flaskId: appBleDevice.identifier);
    _timeoutDuration = startDateAndTime.second;
    _startTimeoutTimer();

    final flaskCommand = buildDataPacket(startDateAndTime.first,
        DateTime.now().toLocal().add(const Duration(days: 1)));
    await writeData(serviceId, FlaskCommand.requestBatchLog, flaskCommand);
  }

  // Start the timeout timer
  void _startTimeoutTimer() {
    _timeoutTimer?.cancel();
    _timeoutTimer = Timer(Duration(seconds: _timeoutDuration), _onTimeout);
  }

  // Reset the timeout timer whenever new data is received
  void _resetTimeoutTimer() {
    _timeoutTimer?.cancel();
    _startTimeoutTimer();
  }

  // Handle timeout event (stop listening)
  void _onTimeout() {
    _debugLog('Request data log time ended');

    if (_isRequestingBatch) {
      _debugLog('Data log was being requested');

      sendBatchLogsToBackend();
    } else {
      BleManager().onDataLogRequestChange?.call('', false);
    }
  }

  // Send the accumulated batch logs to the backend
  Future<void> sendBatchLogsToBackend() async {
    // Implement the logic to send the batch logs to the backend
    _debugLog('Called send batch logs to backend method');
    _debugLog(
        'Number of different logs dates available: ${_batchLogs.keys.length}');
    final totalFlaskCount =
        _batchLogs.values.fold(0, (sum, log) => sum + (log['flasks'] as int));
    _debugLog('Number of total cycles available: $totalFlaskCount');
    _debugLog(
        '-----------------------------------------------------------------');
    if (_batchLogs.keys.isNotEmpty) {
      _debugLog('Updating the batch logs to backend');
      _flaskRepository ??= Injector.instance<FlaskRepository>();
      final response = await _flaskRepository?.uploadBLELog(
          flaskSerialId: appBleDevice.identifier,
          log: _batchLogs.entries.map((item) {
            return item.value as Map<String, dynamic>;
          }).toList());
      BleManager().onDataLogRequestChange?.call('', false);
      response?.when(success: (success) {
        _debugLog('Data log uploaded successfully');
        FlaskManager().setFlaskQueryStartDate(flaskId: appBleDevice.identifier);
        BleManager().onNewLog?.call(
            [], 'Backend data log', false, 'Sent data log to backend', true);
        _debugLog('Initiated refresh of home and goal screen');
        Refresher().refreshHomeScreen?.call();
        Refresher().refreshGoalScreen?.call();
        _debugLog('Initiating data log clear ');
        clearDataLog(BleManager().serviceId);
        _setIsRequestingToFlase();
      }, error: (error) {
        _setIsRequestingToFlase();
        _debugLog('Data log upload failed wth reason: $error');
      });
    } else {
      BleManager().onDataLogRequestChange?.call('', false);
      await FlaskManager()
          .setFlaskQueryStartDate(flaskId: appBleDevice.identifier);
      _setIsRequestingToFlase();
    }
  }

  void _setIsRequestingToFlase() {
    Future.delayed(const Duration(seconds: 2), () {
      _isRequestingBatch = false;
    });
  }

  void _debugLog(String message) {
    if (kDebugMode) {
      print('Data Tracking Flow: $message');
    }
    Injector.instance<ApiLogService>().addDataTrackingLog(message);
  }
}
