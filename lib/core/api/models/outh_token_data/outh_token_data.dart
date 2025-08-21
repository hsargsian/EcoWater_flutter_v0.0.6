import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/oauth_token_entity.dart';

part 'outh_token_data.g.dart';

@JsonSerializable()
class OauthTokenData {
  OauthTokenData(this.accessToken, this.refreshToken, this.userId);

  factory OauthTokenData.fromJson(Map<String, dynamic> json) =>
      _$OauthTokenDataFromJson(json);
  @JsonKey(name: 'access')
  final String accessToken;
  @JsonKey(name: 'refresh')
  final String refreshToken;
  @JsonKey(name: 'id')
  final String userId;

  Map<String, dynamic> toJson() => _$OauthTokenDataToJson(this);

  OauthTokenEntity asEntity() => OauthTokenEntity(
      accessToken: accessToken, refreshToken: refreshToken, userId: userId);
}
