part of 'article_learning_library_listing_bloc.dart';

abstract class ArticleLearningLibraryListingState {}

class ArticleLearningLibraryListingIdleState
    extends ArticleLearningLibraryListingState {}

class FetchingArticleLearningLibraryListingState
    extends ArticleLearningLibraryListingState {}

class FetchedArticleLearningLibraryListingState
    extends ArticleLearningLibraryListingState {
  FetchedArticleLearningLibraryListingState();
}

class ArticleLearningLibraryApiErrorState
    extends ArticleLearningLibraryListingState {
  ArticleLearningLibraryApiErrorState(this.errorMessage);
  final String errorMessage;
}
