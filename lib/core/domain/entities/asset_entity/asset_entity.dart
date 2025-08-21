import 'package:freezed_annotation/freezed_annotation.dart';

part 'asset_entity.g.dart';

@JsonSerializable()
class AssetEntity {
  AssetEntity({required this.id, required this.url, required this.isImage});
  factory AssetEntity.fromJson(Map<String, dynamic> json) =>
      _$AssetEntityFromJson(json);
  final String? id;
  final String url;
  final bool isImage;
  Map<String, dynamic> toJson() => _$AssetEntityToJson(this);
}
