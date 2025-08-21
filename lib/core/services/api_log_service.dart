import 'dart:convert';
import 'dart:io';

import 'package:alice/alice.dart';
import 'package:alice/model/alice_configuration.dart';
import 'package:alice_dio/alice_dio_adapter.dart';
import 'package:echowater/core/domain/repositories/other_repository.dart';
import 'package:echowater/core/domain/repositories/user_repository.dart';
import 'package:echowater/flavor_config.dart';
import 'package:echowater/oc_libraries/device_information_retrieval/device_information_retrieval_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ApiLogService {
  ApiLogService() {
    if (!kReleaseMode) {
      _alice = Alice(
          configuration: AliceConfiguration(
              navigatorKey: _navigatorKey,
              showNotification: false,
              showInspectorOnShake: FlavorConfig.isNotProduction()));

      _aliceDioAdapter = AliceDioAdapter();
      _alice.addAdapter(_aliceDioAdapter);
    }
    _getDataTrackingLogs();
  }
  OtherRepository? _otherRepository;
  UserRepository? _userRepository;
  DeviceInformationRetrievalService? _deviceInfoService;

  final _pref = const FlutterSecureStorage();

  final ValueNotifier<List<Map<String, dynamic>>> dataSyncLogsNotifier =
      ValueNotifier([]);

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  late final Alice _alice;

  GlobalKey<NavigatorState>? get navigationKey => _navigatorKey;
  late final AliceDioAdapter _aliceDioAdapter;

  AliceDioAdapter get aliceInterceptor => _aliceDioAdapter;

  void showLog() {
    _alice.showInspector();
  }

  ///////////////////////////////////////////////////////////////////////////

  void addDataTrackingLog(String message) {
    dataSyncLogsNotifier.value = [
      {'message': message, 'date': DateTime.now().toIso8601String()},
      ...dataSyncLogsNotifier.value,
    ];
    _saveDataTrackingLog();
  }

  void clearDataSyncLog() {
    _pref.write(key: 'data_tracking_log', value: jsonEncode([]));
    dataSyncLogsNotifier.value = [];
  }

  Future<String> writeToFile(String content) async {
    final directory = await getTemporaryDirectory();
    final path = '${directory.path}/my_data.txt';
    final file = File(path);

    await file.writeAsString(content);
    return path;
  }

  String listToString() {
    return jsonEncode(dataSyncLogsNotifier.value);
  }

  Future<void> shareDataSyncLog() async {
    final path = await writeToFile(listToString());

    await Share.shareXFiles(
      [
        XFile(path),
      ],
      text: 'BLE Log',
      subject: 'SAA',
    );
  }

  void _saveDataTrackingLog() {
    _pref.write(
        key: 'data_tracking_log',
        value: jsonEncode(dataSyncLogsNotifier.value));
  }

  Future<void> _getDataTrackingLogs() async {
    final response = await _pref.read(key: 'data_tracking_log');
    if (response != null) {
      final tracks = (jsonDecode(response) as List<dynamic>)
          .map((item) {
            if (item is String) {
              return {'message': item};
            } else if (item is Map<String, dynamic>) {
              if (item['message'] is String) {
                return {'message': item['message'], 'date': item['date']};
              }
              return null;
            } else {
              return null;
            }
          })
          .where((item) => item != null)
          .map((item) => item!)
          .toList();
      dataSyncLogsNotifier.value = tracks;
      _saveDataTrackingLog();
    }
  }
}
