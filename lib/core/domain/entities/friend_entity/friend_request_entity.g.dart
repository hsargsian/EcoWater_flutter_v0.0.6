// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_request_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FriendRequestEntity _$FriendRequestEntityFromJson(Map<String, dynamic> json) =>
    FriendRequestEntity(
      json['id'] as String,
      UserEntity.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FriendRequestEntityToJson(
        FriendRequestEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user': instance.user,
    };
