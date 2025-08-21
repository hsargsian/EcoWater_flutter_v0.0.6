import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/article_learning_library_entity/article_learning_library_entity.dart';

part 'article_learning_library_data.g.dart';

@JsonSerializable()
class ArticleLearningLibraryData {
  ArticleLearningLibraryData(
      this.id, this.title, this.thumbnail, this.url, this.order);

  factory ArticleLearningLibraryData.fromJson(Map<String, dynamic> json) =>
      _$ArticleLearningLibraryDataFromJson(json);

  final String id;
  final String title;
  final String? thumbnail;
  final String url;
  final int? order;

  Map<String, dynamic> toJson() => _$ArticleLearningLibraryDataToJson(this);

  ArticleLearningLibraryEntity asEntity() => ArticleLearningLibraryEntity(
        id,
        title,
        thumbnail,
        url,
        order ?? 0,
        false,
      );
}
