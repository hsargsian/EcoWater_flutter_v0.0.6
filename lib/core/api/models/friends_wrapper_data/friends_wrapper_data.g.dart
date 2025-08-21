// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friends_wrapper_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FriendsWrapperData _$FriendsWrapperDataFromJson(Map<String, dynamic> json) =>
    FriendsWrapperData(
      (json['results'] as List<dynamic>)
          .map((e) => FriendData.fromJson(e as Map<String, dynamic>))
          .toList(),
      PageMetaData.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FriendsWrapperDataToJson(FriendsWrapperData instance) =>
    <String, dynamic>{
      'results': instance.friends,
      'meta': instance.pageMeta,
    };
