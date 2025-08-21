import 'package:bloc/bloc.dart';
import 'package:echowater/core/domain/domain_models/video_learning_library_wrapper_domain.dart';
import 'package:echowater/core/domain/repositories/learning_repository.dart';
import 'package:flutter/material.dart';

import '../../../../../core/domain/domain_models/fetch_style.dart';

part 'video_learning_library_listing_event.dart';
part 'video_learning_library_listing_state.dart';

class VideoLearningLibraryListingBloc extends Bloc<
    VideoLearningLibraryListingEvent, VideoLearningLibraryListingState> {
  VideoLearningLibraryListingBloc(
      {required LearningRepository learningRepository})
      : _learningRepository = learningRepository,
        super(VideoLearningLibraryListingIdleState()) {
    on<FetchVideoLearningLibraryListingEvent>(_onFetchVideoLearningLibrary);
    on<SetVideoLearningLibraryListingType>(
        _onSetVideoLearningLibraryListingType);
  }
  final LearningRepository _learningRepository;

  bool isSubsectionView = false;

  VideoLearningLibraryWrapperDomain videoWrapper =
      VideoLearningLibraryWrapperDomain(
    true,
    [],
  );

  Future<void> _onSetVideoLearningLibraryListingType(
    SetVideoLearningLibraryListingType event,
    Emitter<VideoLearningLibraryListingState> emit,
  ) async {
    isSubsectionView = event.isSubSectionView;
  }

  Future<void> _onFetchVideoLearningLibrary(
    FetchVideoLearningLibraryListingEvent event,
    Emitter<VideoLearningLibraryListingState> emit,
  ) async {
    emit(FetchingVideoLearningLibraryListingState());
    var offset = 0;
    switch (event.fetchStyle) {
      case FetchStyle.normal:
      case FetchStyle.pullToRefresh:
        videoWrapper = VideoLearningLibraryWrapperDomain(
          true,
          [],
        );
      case FetchStyle.loadMore:
        offset = videoWrapper.videos.length;
    }

    final response = await _learningRepository.fetchVideoLibrary(
        offset: offset, perPage: 10);
    response.when(success: (videosResponse) {
      switch (event.fetchStyle) {
        case FetchStyle.normal:
        case FetchStyle.pullToRefresh:
          videoWrapper = videosResponse.toDomain();
        case FetchStyle.loadMore:
          videoWrapper.hasMore = videosResponse.pageMeta.hasMore;
          videoWrapper.videos
              .addAll(videosResponse.videos.map((e) => e.toDomain()).toList());
      }
      if (isSubsectionView) {
        videoWrapper.addSeeMoreIfNecessary();
      }
      emit(FetchedVideoLearningLibraryListingState());
    }, error: (error) {
      emit(VideoLearningLibraryApiErrorState(error.toMessage()));
    });
  }
}
