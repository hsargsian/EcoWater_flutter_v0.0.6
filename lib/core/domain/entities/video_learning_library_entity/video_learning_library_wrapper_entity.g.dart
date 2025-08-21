// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_learning_library_wrapper_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoLearningLibraryWrapperEntity _$VideoLearningLibraryWrapperEntityFromJson(
        Map<String, dynamic> json) =>
    VideoLearningLibraryWrapperEntity(
      (json['videos'] as List<dynamic>)
          .map((e) =>
              VideoLearningLibraryEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      PageMetaEntity.fromJson(json['pageMeta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VideoLearningLibraryWrapperEntityToJson(
        VideoLearningLibraryWrapperEntity instance) =>
    <String, dynamic>{
      'videos': instance.videos,
      'pageMeta': instance.pageMeta,
    };
