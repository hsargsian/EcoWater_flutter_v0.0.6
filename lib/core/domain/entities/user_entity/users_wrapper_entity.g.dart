// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users_wrapper_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UsersWrapperEntity _$UsersWrapperEntityFromJson(Map<String, dynamic> json) =>
    UsersWrapperEntity(
      (json['users'] as List<dynamic>)
          .map((e) => UserEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      PageMetaEntity.fromJson(json['pageMeta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UsersWrapperEntityToJson(UsersWrapperEntity instance) =>
    <String, dynamic>{
      'users': instance.users,
      'pageMeta': instance.pageMeta,
    };
