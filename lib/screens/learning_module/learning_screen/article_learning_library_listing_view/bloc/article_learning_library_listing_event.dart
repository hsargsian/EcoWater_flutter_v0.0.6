part of 'article_learning_library_listing_bloc.dart';

@immutable
abstract class ArticleLearningLibraryListingEvent {}

class FetchArticleLearningLibraryListingEvent
    extends ArticleLearningLibraryListingEvent {
  FetchArticleLearningLibraryListingEvent(this.fetchStyle);
  final FetchStyle fetchStyle;
}

class SetArticleLearningLibraryListingType
    extends ArticleLearningLibraryListingEvent {
  SetArticleLearningLibraryListingType(this.isSubSectionView);
  final bool isSubSectionView;
}
