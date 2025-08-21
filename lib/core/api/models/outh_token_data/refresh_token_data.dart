import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/refresh_token_entity.dart';

part 'refresh_token_data.g.dart';

@JsonSerializable()
class RefreshTokenData {
  RefreshTokenData(this.accessToken);

  factory RefreshTokenData.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenDataFromJson(json);
  @JsonKey(name: 'access')
  final String accessToken;

  Map<String, dynamic> toJson() => _$RefreshTokenDataToJson(this);

  RefreshTokenEntity asEntity() => RefreshTokenEntity(accessToken: accessToken);
}
