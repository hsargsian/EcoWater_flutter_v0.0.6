// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FriendEntity _$FriendEntityFromJson(Map<String, dynamic> json) => FriendEntity(
      json['id'] as String,
      UserEntity.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FriendEntityToJson(FriendEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user': instance.user,
    };
