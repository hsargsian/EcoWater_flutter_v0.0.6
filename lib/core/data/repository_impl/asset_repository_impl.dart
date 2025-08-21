import 'dart:async';
import 'dart:io';

import '../../api/exceptions/custom_exception.dart';
import '../../api/resource/resource.dart';
import '../../domain/entities/asset_entity/asset_entity.dart';
import '../../domain/repositories/asset_repository.dart';
import '../data_sources/asset_data_sources/asset_remote_datasource.dart';

class AssetRepositoryImpl implements AssetRepository {
  AssetRepositoryImpl({required AssetRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  final AssetRemoteDataSource _remoteDataSource;

  @override
  Future<Result<AssetEntity>> uploadAsset(String type, File file) async {
    try {
      final uploadResponse = await _remoteDataSource.uploadAsset(type, file);
      return Result.success(uploadResponse.asEntity());
    } on CustomException catch (e) {
      return Result.error(e);
    }
  }
}
