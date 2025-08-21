// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'oauth_token_wrapper_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OauthTokenWrapperData _$OauthTokenWrapperDataFromJson(
        Map<String, dynamic> json) =>
    OauthTokenWrapperData(
      OauthTokenData.fromJson(json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OauthTokenWrapperDataToJson(
        OauthTokenWrapperData instance) =>
    <String, dynamic>{
      'result': instance.result,
    };
