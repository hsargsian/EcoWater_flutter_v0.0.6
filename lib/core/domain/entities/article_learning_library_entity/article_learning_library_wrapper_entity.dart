import 'package:json_annotation/json_annotation.dart';

import '../../domain_models/article_learning_library_wrapper_domain.dart';
import '../page_meta_entity/page_meta_entity.dart';
import 'article_learning_library_entity.dart';

part 'article_learning_library_wrapper_entity.g.dart';

@JsonSerializable()
class ArticleLearningLibraryWrapperEntity {
  ArticleLearningLibraryWrapperEntity(
    this.articles,
    this.pageMeta,
  );

  factory ArticleLearningLibraryWrapperEntity.fromJson(
          Map<String, dynamic> json) =>
      _$ArticleLearningLibraryWrapperEntityFromJson(json);

  final List<ArticleLearningLibraryEntity> articles;
  final PageMetaEntity pageMeta;

  Map<String, dynamic> toJson() =>
      _$ArticleLearningLibraryWrapperEntityToJson(this);
  ArticleLearningLibraryWrapperDomain toDomain() =>
      ArticleLearningLibraryWrapperDomain(
          pageMeta.hasMore, articles.map((e) => e.toDomain()).toList());
}
