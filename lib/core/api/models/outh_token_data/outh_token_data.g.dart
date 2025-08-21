// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'outh_token_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OauthTokenData _$OauthTokenDataFromJson(Map<String, dynamic> json) =>
    OauthTokenData(
      json['access'] as String,
      json['refresh'] as String,
      json['id'] as String,
    );

Map<String, dynamic> _$OauthTokenDataToJson(OauthTokenData instance) =>
    <String, dynamic>{
      'access': instance.accessToken,
      'refresh': instance.refreshToken,
      'id': instance.userId,
    };
