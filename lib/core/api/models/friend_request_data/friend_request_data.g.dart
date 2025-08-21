// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_request_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FriendRequestData _$FriendRequestDataFromJson(Map<String, dynamic> json) =>
    FriendRequestData(
      json['id'] as String,
      UserData.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FriendRequestDataToJson(FriendRequestData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user': instance.user,
    };
