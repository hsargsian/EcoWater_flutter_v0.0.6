// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_learning_library_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArticleLearningLibraryData _$ArticleLearningLibraryDataFromJson(
        Map<String, dynamic> json) =>
    ArticleLearningLibraryData(
      json['id'] as String,
      json['title'] as String,
      json['thumbnail'] as String?,
      json['url'] as String,
      json['order'] as int?,
    );

Map<String, dynamic> _$ArticleLearningLibraryDataToJson(
        ArticleLearningLibraryData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'thumbnail': instance.thumbnail,
      'url': instance.url,
      'order': instance.order,
    };
