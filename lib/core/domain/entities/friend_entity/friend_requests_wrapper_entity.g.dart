// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_requests_wrapper_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FriendRequestsWrapperEntity _$FriendRequestsWrapperEntityFromJson(
        Map<String, dynamic> json) =>
    FriendRequestsWrapperEntity(
      (json['friendRequests'] as List<dynamic>)
          .map((e) => FriendRequestEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      PageMetaEntity.fromJson(json['pageMeta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FriendRequestsWrapperEntityToJson(
        FriendRequestsWrapperEntity instance) =>
    <String, dynamic>{
      'friendRequests': instance.friendRequests,
      'pageMeta': instance.pageMeta,
    };
