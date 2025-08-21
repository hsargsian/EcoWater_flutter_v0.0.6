// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FriendData _$FriendDataFromJson(Map<String, dynamic> json) => FriendData(
      json['id'] as String,
      UserData.fromJson(json['friend'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FriendDataToJson(FriendData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'friend': instance.user,
    };
