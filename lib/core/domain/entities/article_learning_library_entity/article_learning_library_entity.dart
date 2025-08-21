import 'package:json_annotation/json_annotation.dart';

import '../../domain_models/article_learning_library_domain.dart';

part 'article_learning_library_entity.g.dart';

@JsonSerializable()
class ArticleLearningLibraryEntity {
  ArticleLearningLibraryEntity(this.id, this.title, this.thumbnail, this.url,
      this.order, this.isSeeAllView);

  factory ArticleLearningLibraryEntity.fromJson(Map<String, dynamic> json) =>
      _$ArticleLearningLibraryEntityFromJson(json);

  final String id;
  final String title;
  final String? thumbnail;
  final String url;
  final int order;
  final bool isSeeAllView;

  Map<String, dynamic> toJson() => _$ArticleLearningLibraryEntityToJson(this);
  ArticleLearningLibraryDomain toDomain() => ArticleLearningLibraryDomain(this);
}
