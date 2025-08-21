// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data_wrapper.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDataWrapper _$UserDataWrapperFromJson(Map<String, dynamic> json) =>
    UserDataWrapper(
      (json['results'] as List<dynamic>)
          .map((e) => UserData.fromJson(e as Map<String, dynamic>))
          .toList(),
      PageMetaData.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserDataWrapperToJson(UserDataWrapper instance) =>
    <String, dynamic>{
      'results': instance.users,
      'meta': instance.page,
    };
