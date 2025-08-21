// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_requests_wrapper_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FriendRequestsWrapperData _$FriendRequestsWrapperDataFromJson(
        Map<String, dynamic> json) =>
    FriendRequestsWrapperData(
      (json['results'] as List<dynamic>)
          .map((e) => FriendRequestData.fromJson(e as Map<String, dynamic>))
          .toList(),
      PageMetaData.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FriendRequestsWrapperDataToJson(
        FriendRequestsWrapperData instance) =>
    <String, dynamic>{
      'results': instance.friendRequests,
      'meta': instance.pageMeta,
    };
