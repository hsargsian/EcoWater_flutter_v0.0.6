import 'package:echowater/base/constants/constants.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/article_learning_library_entity/article_learning_library_wrapper_entity.dart';
import '../page_meta_data/page_meta_data.dart';
import 'article_learning_library_data.dart';

part 'article_learning_library_wrapper_data.g.dart';

@JsonSerializable()
class ArticleLearningLibraryWrapperData {
  ArticleLearningLibraryWrapperData(this.articles, this.pageMeta);
  ArticleLearningLibraryWrapperData.dummy()
      : articles = List.generate(
          5,
          (index) => ArticleLearningLibraryData(
            index.toString(),
            'This is article $index',
            null,
            Constants.echowaterUrl,
            1000000000,
          ),
        ),
        pageMeta = PageMetaData(true);

  factory ArticleLearningLibraryWrapperData.fromJson(
          Map<String, dynamic> json) =>
      _$ArticleLearningLibraryWrapperDataFromJson(json);
  @JsonKey(name: 'results')
  final List<ArticleLearningLibraryData> articles;
  @JsonKey(name: 'meta')
  final PageMetaData pageMeta;

  ArticleLearningLibraryWrapperEntity asEntity() =>
      ArticleLearningLibraryWrapperEntity(
          articles.map((e) => e.asEntity()).toList(), pageMeta.asEntity());
}
