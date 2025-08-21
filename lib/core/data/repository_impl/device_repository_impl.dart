import 'dart:async';

import '../../api/exceptions/custom_exception.dart';
import '../../api/resource/resource.dart';
import '../../domain/repositories/device_repository.dart';
import '../data_sources/device_data_sources/device_local_data_source.dart';
import '../data_sources/device_data_sources/device_remote_data_source.dart';

class DeviceRepositoryImpl implements DeviceRepository {
  DeviceRepositoryImpl({
    required DeviceRemoteDataSource remoteDataSource,
    required DeviceLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;
  final DeviceRemoteDataSource _remoteDataSource;
  final DeviceLocalDataSource _localDataSource;

  @override
  Future<Result<bool>> updateDevice(
      {required String deviceId, required String pushToken}) async {
    try {
      final _ = await _remoteDataSource.updateDevice(
        pushToken: pushToken,
      );
      await _localDataSource.saveCurrentDeviceId(deviceId);
      return const Result.success(true);
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<bool>> removeDevice() async {
    final deviceId = await _localDataSource.getCurrentDeviceId();
    if (deviceId == null) {
      return const Result.success(true);
    }
    try {
      final _ = await _remoteDataSource.removeDevice(deviceId: deviceId);
      await _localDataSource.removeDeviceId();
      return const Result.success(true);
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }
}
