import '../../../services/local_storage_service/local_storage_service.dart';

abstract class DeviceLocalDataSource {
  Future<void> saveCurrentDeviceId(String deviceId);
  Future<String?> getCurrentDeviceId();
  Future<void> removeDeviceId();
}

class DeviceLocalDataSourceImpl extends DeviceLocalDataSource {
  DeviceLocalDataSourceImpl({required LocalStorageService localStorageService})
      : _localStorageService = localStorageService;

  final LocalStorageService _localStorageService;

  @override
  Future<String?> getCurrentDeviceId() async {
    return _localStorageService.deviceId;
  }

  @override
  Future<void> saveCurrentDeviceId(String deviceId) async {
    await _localStorageService.setDeviceId(deviceId);
    return;
  }

  @override
  Future<void> removeDeviceId() async {
    await _localStorageService.setDeviceId(null);
  }
}
