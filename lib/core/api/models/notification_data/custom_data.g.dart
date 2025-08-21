// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomData _$CustomDataFromJson(Map<String, dynamic> json) => CustomData(
      socialGoalId: json['social_goal_id'] as String?,
      friendId: json['friend_id'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      url: json['url'] as String?,
      image: json['image'] as String?,
    );

Map<String, dynamic> _$CustomDataToJson(CustomData instance) =>
    <String, dynamic>{
      'social_goal_id': instance.socialGoalId,
      'friend_id': instance.friendId,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'url': instance.url,
      'image': instance.image,
    };
