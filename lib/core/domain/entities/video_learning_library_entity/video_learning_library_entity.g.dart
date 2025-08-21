// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_learning_library_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoLearningLibraryEntity _$VideoLearningLibraryEntityFromJson(
        Map<String, dynamic> json) =>
    VideoLearningLibraryEntity(
      json['id'] as String,
      json['title'] as String,
      json['thumbnail'] as String?,
      json['url'] as String,
      json['isSeeAllView'] as bool,
    );

Map<String, dynamic> _$VideoLearningLibraryEntityToJson(
        VideoLearningLibraryEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'thumbnail': instance.thumbnail,
      'url': instance.url,
      'isSeeAllView': instance.isSeeAllView,
    };
