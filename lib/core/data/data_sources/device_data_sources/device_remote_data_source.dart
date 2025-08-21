import 'package:dio/dio.dart';
import '../../../api/clients/rest_client/authorized_api_client/authorized_api_client.dart';
import '../../../api/exceptions/exception_handler.dart';
import '../../../api/models/empty_success_response/empty_success_response.dart';

abstract class DeviceRemoteDataSource {
  Future<EmptySuccessResponse> updateDevice({
    required String pushToken,
  });
  Future<EmptySuccessResponse> removeDevice({required String deviceId});
}

class DeviceRemoteDataSourceImpl extends DeviceRemoteDataSource {
  DeviceRemoteDataSourceImpl({required AuthorizedApiClient userApiClient})
      : _userApiClient = userApiClient;

  final AuthorizedApiClient _userApiClient;
  CancelToken _updateDeviceCancelToken = CancelToken();

  @override
  Future<EmptySuccessResponse> updateDevice({required String pushToken}) async {
    try {
      _updateDeviceCancelToken.cancel();
      _updateDeviceCancelToken = CancelToken();
      return await _userApiClient.updateDevice(
          pushToken, _updateDeviceCancelToken);
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<EmptySuccessResponse> removeDevice({required String deviceId}) async {
    try {
      return await _userApiClient.removeDevice(deviceId);
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }
}
