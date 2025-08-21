import 'device_information.dart';
import 'package_information.dart';

abstract class DeviceInformationRetrievalService {
  Future<DeviceInformation> fetchDeviceInformation();
  Future<PackageInformation> fetchPackageInformation();
}
