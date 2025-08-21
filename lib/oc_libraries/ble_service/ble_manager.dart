import 'dart:async';

import 'package:echowater/base/utils/pair.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/base/utils/utilities.dart';
import 'package:echowater/core/data/repository_impl/flask_repository_impl.dart';
import 'package:echowater/core/domain/domain_models/flask_domain.dart';
import 'package:echowater/core/domain/domain_models/usage_streak_domain.dart';
import 'package:echowater/core/domain/repositories/flask_repository.dart';
import 'package:echowater/core/injector/injector.dart';
import 'package:echowater/oc_libraries/ble_service/ble_constants.dart';
import 'package:echowater/oc_libraries/ble_service/single_ble_device_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/domain/domain_models/flask_option.dart';
import '../../core/domain/domain_models/todays_progress_domain.dart';
import '../../screens/profile_module/ble_configurator_screen/ble_configurator_screen.dart';
import 'app_ble_model.dart';

class BleManager {
  factory BleManager() {
    return _instance;
  }

  BleManager._internal();

  String serviceId = '';

  void Function(BluetoothAdapterState state)? onStateChanged;
  void Function()? initiateFlaskFetchSearchAndPair;
  void Function(String message, bool isRequestingDataLog)?
      onDataLogRequestChange;
  void Function(AppBleModel device, bool flag)? onDeviceConnected;
  void Function(AppBleModel device, double? ppmGenerated)? onCycleRun;

  void Function(AppBleModel device, double? mcu)? onFlaskMCURead;
  void Function(bool connected)? onFlaskStateChanges;
  final Map<String, SingleBLEDeviceManager> connectedDevices = {};
  List<String> _myFlaskIds = [];
  List<AppBleModel> scanResultsListing = [];
  final int _scanTime = 5;

  bool isUserLoggedIn = false;

  static final BleManager _instance = BleManager._internal();

  int retryCount = 0;
  Timer writeTimer = Timer(Duration.zero, () => {});
  Timer? _stopTimer;

  StreamSubscription<BluetoothAdapterState>? _bluetoothStateSubscription;
  final StreamController<List<AppBleModel>> _scanResultsController =
      StreamController<List<AppBleModel>>.broadcast();

  StreamSubscription<List<ScanResult>>? _scanResultsSubscription;

  Function()? onSearchComplete;
  void Function(List<int>, String?, bool, String?, bool isBatchData)? onNewLog;

  Stream<List<AppBleModel>> get scanResults => _scanResultsController.stream;

  List<String> cycleRunningFlasks = [];

  FlaskRepository? _flaskRepository;

  bool isInitialized = false;

  Future<Pair<bool, String?>> initService() async {
    if (!isUserLoggedIn) {
      return Pair(first: false, second: null);
    }
    _addBluetoothStateChangeListener();
    final injector = Injector.instance;
    _flaskRepository ??= FlaskRepositoryImpl(
        remoteDataSource: injector(),
        localDataSource: injector(),
        marketingPushService: injector(),
        cacheAndRetryService: injector());
    serviceId = await const FlutterSecureStorage().read(key: 'serviceUUId') ??
        BleConstants.serviceUUID;

    final bleCheckResponse = await Utilities.checkBLEState();
    if (!bleCheckResponse.first) {
      return bleCheckResponse;
    }

    await FlutterBluePlus.setOptions();

    isInitialized = true;
    await FlutterBluePlus.setLogLevel(
        kDebugMode ? LogLevel.debug : LogLevel.none);

    _addScanResultListener();
    return Pair(first: true, second: null);
  }

  void updateMyFlasks(List<String> ids) {
    _myFlaskIds = ids;
  }

  void dispose() {
    isUserLoggedIn = false;
    _bluetoothStateSubscription?.cancel();
    _myFlaskIds = [];
    disconnectAllDevices();
    _scanResultsController.close();
    _scanResultsSubscription?.cancel();
    if (!_scanResultsController.isClosed) {
      _scanResultsController.close(); // Close only when disposing
    }
    connectedDevices.clear();
    scanResultsListing = [];
    stopScan();
  }

  void startScan({List<String> withRemoteIds = const [], int? connectTime}) {
    final alreadyConnectedDevices = FlutterBluePlus.connectedDevices;
    for (final item in alreadyConnectedDevices) {
      final newAppBleModel = AppBleModel(
          identifier: item.remoteId.toString(),
          bleDevice: item,
          state: BLEDeviceState.connected,
          rssi: 0);
      connect(device: newAppBleModel, isAlreadyConnected: true);
    }
    scanResultsListing = [];
    _stopTimer = Timer(Duration(seconds: connectTime ?? _scanTime), () {
      stopScan(onTimerEnd: true);
    });

    FlutterBluePlus.startScan(
        withRemoteIds: withRemoteIds,
        withServices: [Guid.fromString(BleConstants.serviceUUID)]);
  }

  void stopScan({bool onTimerEnd = false}) {
    FlutterBluePlus.stopScan();
    _stopTimer?.cancel();
    _stopTimer = null;
    if (onTimerEnd) {
      onSearchComplete?.call();
    }
  }

  Future<void> disconnectAllDevices() async {
    connectedDevices.forEach((_, device) => device.disconnect());

    final baseConnectedDevices = await FlutterBluePlus.systemDevices([]);

    for (final device in baseConnectedDevices) {
      await device.disconnect();
    }
  }

  Future<void> connect(
      {required AppBleModel device, required bool isAlreadyConnected}) async {
    if (!connectedDevices.containsKey(device.identifier)) {
      final item = SingleBLEDeviceManager(device, _onDeviceStateChanged);
      connectedDevices[device.identifier] = item;
      await connectedDevices[device.identifier]?.connect(isAlreadyConnected);
    }
  }

  Future<void> connectFlask(
      {required FlaskDomain device, int? connectTime}) async {
    startScan(withRemoteIds: [device.serialId], connectTime: connectTime);
  }

  Future<void> disconnect(FlaskDomain device) async {
    final key = device.appBleModelDevice?.identifier ?? device.serialId;
    if (connectedDevices.containsKey(key)) {
      await connectedDevices[key]?.disconnect();
      connectedDevices.remove(key);
    } else {
      Utilities.bleLog('could not find');
    }
  }

  bool isConnected(AppBleModel device) {
    if (device.bleDevice.isConnected &&
        !connectedDevices.containsKey(device.identifier)) {
      connect(device: device, isAlreadyConnected: true);
    }
    return connectedDevices.containsKey(device.identifier);
  }

  String stateString(AppBleModel device) {
    return device.state.title;
  }

  void _addBluetoothStateChangeListener() {
    _bluetoothStateSubscription?.cancel();
    _bluetoothStateSubscription = FlutterBluePlus.adapterState.listen((state) {
      Utilities.bleLog(state);
      onStateChanged?.call(state);
    });
  }

  void _addScanResultListener() {
    Utilities.bleLog('Adding scan result listener');
    _scanResultsSubscription?.cancel();
    _scanResultsSubscription = FlutterBluePlus.onScanResults.listen((event) {
      for (final item in event) {
        final index = scanResultsListing.indexWhere(
            (result) => result.identifier == item.device.remoteId.toString());

        if (index == -1) {
          final newAppBleModel = AppBleModel(
              identifier: item.device.remoteId.toString(),
              bleDevice: item.device,
              state: BLEDeviceState.disconnected,
              rssi: item.rssi);

          if (_myFlaskIds.contains(item.device.remoteId.toString())) {
            Utilities.bleLog(item.device.advName);
            Utilities.bleLog(item.device.remoteId.toString());
            Utilities.bleLog('=======================');
            Utilities.bleLog('connecting ${item.device.advName}');
            connect(device: newAppBleModel, isAlreadyConnected: false);
          } else {
            scanResultsListing.add(newAppBleModel);
            _sortByStrength();
            try {
              if (!_scanResultsController.isClosed) {
                _scanResultsController.add(scanResultsListing);
              }
            } catch (e, _) {
              if (kDebugMode) {
                print('Error adding scan result: $e');
              }
            }
          }
        }
      }
    }, onError: (e) {
      if (kDebugMode) {
        print('Error adding scan result: $e');
      }
    });
  }

  void _sortByStrength() {
    scanResultsListing.sort((a, b) {
      return a.rssi < b.rssi ? 1 : -1;
    });
  }

  void _onDeviceStateChanged(
      SingleBLEDeviceManager manager, BluetoothConnectionState state) {
    if (state == BluetoothConnectionState.connected) {
      connectedDevices[manager.appBleDevice.identifier] = manager;
      onDeviceConnected?.call(manager.appBleDevice, true);
      onFlaskStateChanges?.call(true);
    } else if (state == BluetoothConnectionState.disconnected) {
      manager.dispose();
      connectedDevices.remove(manager.appBleDevice.identifier);
      onDeviceConnected?.call(manager.appBleDevice, false);
      onFlaskStateChanges?.call(false);
    }
  }

  String? getFirmwareVersion(FlaskDomain flask) {
    final key = flask.appBleModelDevice?.identifier ?? flask.serialId;
    if (connectedDevices.containsKey(key)) {
      return connectedDevices[key]?.bleVersion;
    } else {
      return null;
    }
  }

  Future<void> disconnectModel(AppBleModel? device) async {
    final key = device?.identifier;
    if (connectedDevices.containsKey(key)) {
      await connectedDevices[key]?.disconnect();
      connectedDevices.remove(key);
    } else {
      Utilities.bleLog('could not find');
    }
  }

  Future<String> sendData(
      FlaskDomain device, FlaskCommand command, List<int> data) async {
    if (connectedDevices.containsKey(device.serialId)) {
      if (command == FlaskCommand.startCycle) {
        cycleRunningFlasks.add(device.appBleModelDevice!.identifier);
      } else {
        cycleRunningFlasks.remove(device.appBleModelDevice!.identifier);
      }
      await connectedDevices[device.serialId]
          ?.writeData(serviceId, command, data);
      return Future.value('');
    } else {
      onNewLog?.call(data, command.name, true,
          'The device is not connected. Please connect first', false);
      device.appBleModelDevice = null;
      return Future.value('The device is not connected. Please connect first');
    }
  }

  void updateScanResultListener({required bool isPause}) {
    if (isPause) {
      _scanResultsSubscription?.pause();
    } else {
      _scanResultsSubscription?.resume();
    }
  }

  void updateInternetBasedTime(SingleBLEDeviceManager manager) {
    final flaskCommand = FlaskCommand.updateInternetBasedTime.commandData
        .addingUnixTime()
        .addingCRC();
    manager.writeData(
        serviceId, FlaskCommand.updateInternetBasedTime, flaskCommand);
  }

  void requestBatchData(SingleBLEDeviceManager manager) {
    manager.requestBatchData(serviceId);
  }

  void clearDataLog(SingleBLEDeviceManager manager) {
    manager.clearDataLog(serviceId);
  }

  Future<void> updateGoals(TodaysProgressDomain progress) async {
    for (final item in connectedDevices.keys.toList()) {
      final flaskCommand = FlaskCommand.updateFlaskGoal.commandData
        ..add(progress.bottleTotal);
      await connectedDevices[item]?.writeData(
          serviceId, FlaskCommand.updateFlaskGoal, flaskCommand.addingCRC());
      await Future.delayed(Duration(milliseconds: throttleSliderValue));

      final h2Command = FlaskCommand.updateH2Goal.commandData
        ..add(progress.ppmTotal);
      await connectedDevices[item]?.writeData(
          serviceId, FlaskCommand.updateH2Goal, h2Command.addingCRC());
      await Future.delayed(Duration(milliseconds: throttleSliderValue));
    }
  }

  Future<void> updateStreaks(UsageStreakDomain streak) async {
    for (final item in connectedDevices.keys.toList()) {
      final streakCommand = FlaskCommand.updateStreakGoal.commandData
        ..add(streak.streak);
      await connectedDevices[item]?.writeData(
          serviceId, FlaskCommand.updateStreakGoal, streakCommand.addingCRC());

      await Future.delayed(Duration(milliseconds: throttleSliderValue));
    }
  }

  SingleBLEDeviceManager? getManager(FlaskDomain flask) {
    if (connectedDevices.containsKey(flask.serialId)) {
      return connectedDevices[flask.serialId]!;
    }
    return null;
  }

  void updateFirmwareLog(FlaskDomain flask, String type) {
    _flaskRepository?.updateFirmwareLog(
        flaskSerialId: flask.serialId, updateType: type);
  }

  void requestAllBatchData() {
    connectedDevices.forEach((key, value) {
      requestBatchData(value);
    });
  }
}
