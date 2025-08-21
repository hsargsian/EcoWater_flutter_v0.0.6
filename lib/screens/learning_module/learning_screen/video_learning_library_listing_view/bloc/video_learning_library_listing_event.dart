part of 'video_learning_library_listing_bloc.dart';

@immutable
abstract class VideoLearningLibraryListingEvent {}

class FetchVideoLearningLibraryListingEvent
    extends VideoLearningLibraryListingEvent {
  FetchVideoLearningLibraryListingEvent(this.fetchStyle);
  final FetchStyle fetchStyle;
}

class SetVideoLearningLibraryListingType
    extends VideoLearningLibraryListingEvent {
  SetVideoLearningLibraryListingType(this.isSubSectionView);
  final bool isSubSectionView;
}
