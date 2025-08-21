// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserEntity _$UserEntityFromJson(Map<String, dynamic> json) => UserEntity(
      json['id'] as String,
      json['email'] as String,
      json['firstName'] as String,
      json['lastName'] as String,
      json['phoneNumber'] as String?,
      json['countryName'] as String,
      json['countryCode'] as String,
      json['avatarImage'] as String?,
      json['theme'] as String,
      json['verified'] as bool,
      json['hasPairedDevice'] as bool,
      json['streaks'] as int,
      json['friendCount'] as int,
      json['friendStatus'] as String,
      json['createdAt'] as String?,
      json['isHealthIntegrationEnabled'] as bool,
    );

Map<String, dynamic> _$UserEntityToJson(UserEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'phoneNumber': instance.phoneNumber,
      'countryName': instance.countryName,
      'countryCode': instance.countryCode,
      'avatarImage': instance.avatarImage,
      'theme': instance.theme,
      'verified': instance.verified,
      'hasPairedDevice': instance.hasPairedDevice,
      'streaks': instance.streaks,
      'friendCount': instance.friendCount,
      'friendStatus': instance.friendStatus,
      'createdAt': instance.createdAt,
      'isHealthIntegrationEnabled': instance.isHealthIntegrationEnabled,
    };
