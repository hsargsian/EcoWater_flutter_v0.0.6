import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/asset_entity/asset_entity.dart';

part 'asset_data.g.dart';

@JsonSerializable()
class AssetData {
  AssetData(this.id, this.url);

  factory AssetData.fromJson(Map<String, dynamic> json) =>
      _$AssetDataFromJson(json);
  final String? id;
  final String url;

  Map<String, dynamic> toJson() => _$AssetDataToJson(this);

  AssetEntity asEntity() => AssetEntity(
        id: id,
        url: url,
        isImage: url.toLowerCase().endsWith('.jpg'),
      );
}
