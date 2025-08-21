// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_learning_library_wrapper_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoLearningLibraryWrapperData _$VideoLearningLibraryWrapperDataFromJson(
        Map<String, dynamic> json) =>
    VideoLearningLibraryWrapperData(
      (json['results'] as List<dynamic>)
          .map((e) =>
              VideoLearningLibraryData.fromJson(e as Map<String, dynamic>))
          .toList(),
      PageMetaData.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VideoLearningLibraryWrapperDataToJson(
        VideoLearningLibraryWrapperData instance) =>
    <String, dynamic>{
      'results': instance.videos,
      'meta': instance.pageMeta,
    };
