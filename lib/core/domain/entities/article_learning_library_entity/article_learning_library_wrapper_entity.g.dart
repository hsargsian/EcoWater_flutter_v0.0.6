// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_learning_library_wrapper_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArticleLearningLibraryWrapperEntity
    _$ArticleLearningLibraryWrapperEntityFromJson(Map<String, dynamic> json) =>
        ArticleLearningLibraryWrapperEntity(
          (json['articles'] as List<dynamic>)
              .map((e) => ArticleLearningLibraryEntity.fromJson(
                  e as Map<String, dynamic>))
              .toList(),
          PageMetaEntity.fromJson(json['pageMeta'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$ArticleLearningLibraryWrapperEntityToJson(
        ArticleLearningLibraryWrapperEntity instance) =>
    <String, dynamic>{
      'articles': instance.articles,
      'pageMeta': instance.pageMeta,
    };
