import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:echowater/base/utils/date_utils.dart';
import 'package:echowater/core/domain/repositories/flask_repository.dart';
import 'package:echowater/core/injector/injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../base/utils/pair.dart';
import 'ble_manager.dart';

class FlaskManager with WidgetsBindingObserver {
  factory FlaskManager() {
    return _instance;
  }

  FlaskManager._internal();

  static final FlaskManager _instance = FlaskManager._internal();

  FlaskRepository? _flaskRepository;
  StreamSubscription<List<ConnectivityResult>>? _internetSubscription;
  final _pollDuration = 120; //seconds
  final _pref = const FlutterSecureStorage();

  bool _isInitialized = false;
  bool _canPoll = true;
  Timer? _pollingTimer;

  void initialize() {
    WidgetsBinding.instance.addObserver(this);
    _isInitialized = true;
    _flaskRepository = Injector.instance<FlaskRepository>();
    _addNetworkConnectionSubscription();
    _initiatePollingTimer();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _canPoll = (state == AppLifecycleState.resumed);
  }

  void _addNetworkConnectionSubscription() {
    _internetSubscription?.cancel();
    _internetSubscription =
        Connectivity().onConnectivityChanged.listen((result) {
      Future.delayed(const Duration(seconds: 1), () async {
        final hasInternet = (await Connectivity().checkConnectivity()).first !=
            ConnectivityResult.none;
        if (hasInternet && BleManager().isUserLoggedIn) {
          await _onPollTriggered();
        }
      });
    });
  }

  void _initiatePollingTimer() {
    _pollingTimer?.cancel();
    Future.delayed(const Duration(seconds: 15), () {
      _onPollTriggered();
      _pollingTimer = Timer.periodic(Duration(seconds: _pollDuration), (_) {
        _onPollTriggered();
      });
    });
  }

  Future<void> _onPollTriggered() async {
    if (!_canPoll) {
      return;
    }
    final isBluetoothConnected =
        await FlutterBluePlus.adapterState.first == BluetoothAdapterState.on;
    if (!isBluetoothConnected) {
      return;
    }
    final response =
        await _flaskRepository?.fetchMyFlasks(offset: 0, perPage: 100);
    response?.when(
        success: (devicesResponse) {
          final bleDevicesWrapper = devicesResponse.toDomain();
          final connectedDevicesKeys =
              BleManager().connectedDevices.keys.toList().toSet();
          final myDevicesKeys = bleDevicesWrapper.flaskIds.toSet();
          final notConnectedDevices =
              myDevicesKeys.difference(connectedDevicesKeys);
          BleManager().updateMyFlasks(bleDevicesWrapper.flaskIds);
          if (notConnectedDevices.isNotEmpty) {
            BleManager().stopScan();
            BleManager().startScan(connectTime: 10);
          } else {
            BleManager().requestAllBatchData();
          }
        },
        error: (error) {});
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _isInitialized = false;
    _pollingTimer?.cancel();
    _internetSubscription?.cancel();
  }

  Future<Pair<DateTime, int>> getFlaskQueryStartDate(
      {required String flaskId}) async {
    final startDate = await _pref.read(key: flaskId);
    if (startDate == null) {
      return Pair(first: DateTime(2025, 01, 05), second: 8);
    }
    final date = DateUtil.getDateObj('yyyy-MM-dd', startDate);
    if (DateTime.now().difference(date).inDays > 7) {
      return Pair(first: date, second: 8);
    }
    return Pair(first: date, second: 4);
  }

  Future<void> setFlaskQueryStartDate({required String flaskId}) async {
    await _pref.write(
        key: flaskId,
        value: DateTime.now()
            .toLocal()
            .subtract(const Duration(days: 3))
            .humanReadableDateString(hasShortHad: false, format: 'yyyy-MM-dd'));
  }
}
