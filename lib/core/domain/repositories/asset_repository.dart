import 'dart:io';

import '../../api/resource/resource.dart';
import '../entities/asset_entity/asset_entity.dart';

abstract class AssetRepository {
  Future<Result<AssetEntity>> uploadAsset(String type, File file);
}
