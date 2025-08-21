import '../../../base/constants/constants.dart';
import '../entities/article_learning_library_entity/article_learning_library_entity.dart';
import 'article_learning_library_domain.dart';

class ArticleLearningLibraryWrapperDomain {
  ArticleLearningLibraryWrapperDomain(this.hasMore, this.articles);
  bool hasMore;
  List<ArticleLearningLibraryDomain> articles;

  void remove({required ArticleLearningLibraryDomain article}) {
    articles.remove(article);
  }

  void sortArticles() {
    articles.sort((a, b) => a.order < b.order ? 0 : 1);
  }

  void addSeeMoreIfNecessary() {
    articles.add(ArticleLearningLibraryDomain(ArticleLearningLibraryEntity(
      '-1',
      '',
      null,
      Constants.echowaterUrl,
      10000000000,
      true,
    )));
  }
}
