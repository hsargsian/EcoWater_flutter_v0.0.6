// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_learning_library_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArticleLearningLibraryEntity _$ArticleLearningLibraryEntityFromJson(
        Map<String, dynamic> json) =>
    ArticleLearningLibraryEntity(
      json['id'] as String,
      json['title'] as String,
      json['thumbnail'] as String?,
      json['url'] as String,
      json['order'] as int,
      json['isSeeAllView'] as bool,
    );

Map<String, dynamic> _$ArticleLearningLibraryEntityToJson(
        ArticleLearningLibraryEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'thumbnail': instance.thumbnail,
      'url': instance.url,
      'order': instance.order,
      'isSeeAllView': instance.isSeeAllView,
    };
