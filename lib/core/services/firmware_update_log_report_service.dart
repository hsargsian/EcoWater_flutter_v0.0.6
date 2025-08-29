import 'dart:convert';
import 'dart:io';

import 'package:echowater/core/domain/domain_models/notification_type.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';

import '../../oc_libraries/device_information_retrieval/device_information_retrieval_service.dart';
import '../domain/domain_models/flask_domain.dart';
import '../domain/repositories/other_repository.dart';
import '../domain/repositories/user_repository.dart';
import '../injector/injector.dart';

class FirmwareUpdateLogReportService {
  FirmwareUpdateLogReportService();
  OtherRepository? _otherRepository;
  UserRepository? _userRepository;
  DeviceInformationRetrievalService? _deviceInfoService;

  final _pref = const FlutterSecureStorage();

  FlaskDomain? _flask;

  Map<String, dynamic> _firmwareUpgradeLogReport = {};
  List<Map<String, dynamic>> _firmwareUpgradelogs = [];

  // ignore: use_setters_to_change_properties
  void addFlask({required FlaskDomain flask}) {
    _flask = flask;
  }

  Future<void> initateOldFirmwareUpgradeCacheUpload() async {
    final data = await _pref.read(key: 'firmware_upgrade_tracking_log');
    if (data != null) {
      final dataReport = jsonDecode(data) as Map<String, dynamic>;
      _firmwareUpgradelogs = (dataReport['logs'] as List<dynamic>)
          .map((item) => item as Map<String, dynamic>)
          .toList();
      _firmwareUpgradeLogReport = dataReport;
      await sendFirmwareUpgradeLogReport();
    }
  }

  Future<void> startFirmwareUpgradeLogReport(
      {required FlaskDomain flask}) async {
    _initializeRepositories();
    _flask = flask;
    final user = await _userRepository!.getCurrentUserFromCache();
    final deviceInfo = await _deviceInfoService!.fetchDeviceInformation();
    final packageInfo = await _deviceInfoService!.fetchPackageInformation();
    _firmwareUpgradeLogReport = {
      'flask': flask.entity.toJson(),
      'user': user?.toJson(),
      'device': deviceInfo.toJson(),
      'app': packageInfo.toJson(),
      'logs': _firmwareUpgradelogs
    };
    _cacheFirmwareUpgradeLog();
  }

  Future<void> sendFirmwareUpgradeLogReport(
      {String? mcuVersion, String? bleVersion}) async {
    _initializeRepositories();
    if (_firmwareUpgradelogs.length < 3) {
      return;
    }
    _firmwareUpgradeLogReport['logs'] = _firmwareUpgradelogs;
    if (mcuVersion != null && bleVersion != null) {
      _firmwareUpgradeLogReport['more_flask_info'] = {
        'mcu_version': mcuVersion,
        'ble_version': bleVersion
      };
    }

    final hasError = _firmwareUpgradelogs.firstWhereOrNull((item) {
          if (item.containsKey('error')) {
            return item['error'] as bool;
          }
          return false;
        }) !=
        null;

    final jsonString = jsonEncode(_firmwareUpgradeLogReport);

    final tempDir = await getTemporaryDirectory();
    final jsonFile = File('${tempDir.path}/log.json');

    await jsonFile.writeAsString(jsonString);
    try {
      await _otherRepository?.addNewLog(_flask?.serialId, hasError, jsonFile);
      if (kDebugMode) {
        print('✅ Firmware upgrade log sent successfully');
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print('⚠️ Failed to send firmware upgrade log (non-critical): $e');
      }
      // Store the failed log for retry later
      await _pref.write(
          key: 'firmware_upgrade_tracking_log_failed', value: jsonString);
    }

    _clearFirmwareUpgradeCacheReport();
  }

  void addFirmwareUpgradeLogReport({required Map<String, dynamic> log}) {
    _initializeRepositories();
    log['timestamp'] = DateTime.now().toLocal().toIso8601String();
    _firmwareUpgradelogs.add(log);
    _cacheFirmwareUpgradeLog();
  }

  void _cacheFirmwareUpgradeLog() {
    _firmwareUpgradeLogReport['logs'] = _firmwareUpgradelogs;
    _pref.write(
        key: 'firmware_upgrade_tracking_log',
        value: jsonEncode(_firmwareUpgradeLogReport));
  }

  void _clearFirmwareUpgradeCacheReport() {
    _pref.write(key: 'firmware_upgrade_tracking_log', value: null);
  }

  ///////////////////////////////////////////////////////////////////////////

  void _initializeRepositories() {
    _otherRepository = Injector.instance<OtherRepository>();
    _userRepository = Injector.instance<UserRepository>();
    _deviceInfoService = Injector.instance<DeviceInformationRetrievalService>();
  }
}
