import 'dart:io';

import '../../../api/clients/rest_client/authorized_api_client/authorized_api_client.dart';
import '../../../api/exceptions/exception_handler.dart';
import '../../../api/models/asset_data/asset_data.dart';

abstract class AssetRemoteDataSource {
  Future<AssetData> uploadAsset(String type, File file);
}

class AssetRemoteDataSourceImpl extends AssetRemoteDataSource {
  AssetRemoteDataSourceImpl({required AuthorizedApiClient userApiClient})
      : _userApiClient = userApiClient;

  final AuthorizedApiClient _userApiClient;

  @override
  Future<AssetData> uploadAsset(String type, File file) async {
    try {
      return await _userApiClient.uploadAsset(type, file);
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }
}
