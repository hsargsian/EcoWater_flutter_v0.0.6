// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_learning_library_wrapper_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArticleLearningLibraryWrapperData _$ArticleLearningLibraryWrapperDataFromJson(
        Map<String, dynamic> json) =>
    ArticleLearningLibraryWrapperData(
      (json['results'] as List<dynamic>)
          .map((e) =>
              ArticleLearningLibraryData.fromJson(e as Map<String, dynamic>))
          .toList(),
      PageMetaData.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ArticleLearningLibraryWrapperDataToJson(
        ArticleLearningLibraryWrapperData instance) =>
    <String, dynamic>{
      'results': instance.articles,
      'meta': instance.pageMeta,
    };
