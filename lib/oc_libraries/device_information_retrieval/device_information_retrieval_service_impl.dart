import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'device_information.dart';
import 'device_information_retrieval_service.dart';
import 'package_information.dart';

class DeviceInformationRetrievalServiceImpl
    implements DeviceInformationRetrievalService {
  DeviceInformationRetrievalServiceImpl._(
      this._deviceInfoPlugin, this._packageInfo);
  late final DeviceInfoPlugin _deviceInfoPlugin;
  late final PackageInfo _packageInfo;

  static Future<DeviceInformationRetrievalServiceImpl> init() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    final packageInfo = await PackageInfo.fromPlatform();
    return DeviceInformationRetrievalServiceImpl._(
        deviceInfoPlugin, packageInfo);
  }

  @override
  Future<DeviceInformation> fetchDeviceInformation() async {
    if (Platform.isAndroid) {
      final androidDeviceInfo = await _deviceInfoPlugin.androidInfo;
      return DeviceInformation(
          name: androidDeviceInfo.fingerprint,
          platform: 'android',
          isPhysicalDevice: true,
          model: androidDeviceInfo.model,
          osVersion: androidDeviceInfo.version.release);
    } else {
      final iosDeviceInfo = await _deviceInfoPlugin.iosInfo;
      return DeviceInformation(
          name: iosDeviceInfo.identifierForVendor ?? '',
          platform: 'ios',
          isPhysicalDevice: iosDeviceInfo.isPhysicalDevice,
          model: iosDeviceInfo.model,
          osVersion: iosDeviceInfo.systemVersion);
    }
  }

  @override
  Future<PackageInformation> fetchPackageInformation() async {
    return PackageInformation(
        appName: _packageInfo.appName,
        packageName: _packageInfo.packageName,
        versionName: _packageInfo.version,
        buildNumber: _packageInfo.buildNumber);
  }
}
