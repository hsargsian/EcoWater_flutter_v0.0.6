// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friends_wrapper_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FriendsWrapperEntity _$FriendsWrapperEntityFromJson(
        Map<String, dynamic> json) =>
    FriendsWrapperEntity(
      (json['friends'] as List<dynamic>)
          .map((e) => FriendEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      PageMetaEntity.fromJson(json['pageMeta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FriendsWrapperEntityToJson(
        FriendsWrapperEntity instance) =>
    <String, dynamic>{
      'friends': instance.friends,
      'pageMeta': instance.pageMeta,
    };
