import '../../api/resource/resource.dart';

abstract class DeviceRepository {
  Future<Result<bool>> updateDevice({
    required String deviceId,
    required String pushToken,
  });

  Future<Result<bool>> removeDevice();
}
