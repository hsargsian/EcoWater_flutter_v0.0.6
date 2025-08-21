// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
      json['id'] as String,
      json['email'] as String,
      json['is_verified'] as bool?,
      json['first_name'] as String,
      json['last_name'] as String,
      json['phone_number'] as String?,
      json['country_name'] as String?,
      json['country_code'] as String?,
      json['image'] as String?,
      json['theme'] as String?,
      json['has_paired_device'] as bool?,
      json['current_streak'] as int?,
      json['friends_count'] as int?,
      json['friend_status'] as String?,
      json['created_at'] as String?,
      json['is_health_integration_enabled'] as bool?,
    );

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'is_verified': instance.verified,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'phone_number': instance.phoneNumber,
      'country_name': instance.countryName,
      'country_code': instance.countryCode,
      'image': instance.avatarImage,
      'theme': instance.theme,
      'has_paired_device': instance.hasPairedDevice,
      'current_streak': instance.streaks,
      'friends_count': instance.friendCount,
      'friend_status': instance.friendStatus,
      'created_at': instance.createdAt,
      'is_health_integration_enabled': instance.isHealthIntegrationEnabled,
    };
