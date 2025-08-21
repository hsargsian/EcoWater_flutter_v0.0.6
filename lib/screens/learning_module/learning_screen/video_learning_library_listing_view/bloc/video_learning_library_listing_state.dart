part of 'video_learning_library_listing_bloc.dart';

abstract class VideoLearningLibraryListingState {}

class VideoLearningLibraryListingIdleState
    extends VideoLearningLibraryListingState {}

class FetchingVideoLearningLibraryListingState
    extends VideoLearningLibraryListingState {}

class FetchedVideoLearningLibraryListingState
    extends VideoLearningLibraryListingState {
  FetchedVideoLearningLibraryListingState();
}

class VideoLearningLibraryApiErrorState
    extends VideoLearningLibraryListingState {
  VideoLearningLibraryApiErrorState(this.errorMessage);
  final String errorMessage;
}
