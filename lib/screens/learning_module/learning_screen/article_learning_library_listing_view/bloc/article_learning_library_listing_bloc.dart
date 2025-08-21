import 'package:bloc/bloc.dart';
import 'package:echowater/core/domain/repositories/learning_repository.dart';
import 'package:flutter/material.dart';

import '../../../../../core/domain/domain_models/article_learning_library_wrapper_domain.dart';
import '../../../../../core/domain/domain_models/fetch_style.dart';

part 'article_learning_library_listing_event.dart';
part 'article_learning_library_listing_state.dart';

class ArticleLearningLibraryListingBloc extends Bloc<
    ArticleLearningLibraryListingEvent, ArticleLearningLibraryListingState> {
  ArticleLearningLibraryListingBloc(
      {required LearningRepository learningRepository})
      : _learningRepository = learningRepository,
        super(ArticleLearningLibraryListingIdleState()) {
    on<FetchArticleLearningLibraryListingEvent>(_onFetchArticleLearningLibrary);
    on<SetArticleLearningLibraryListingType>(
        _onSetArticleLearningLibraryListingType);
  }
  final LearningRepository _learningRepository;

  bool isSubsectionView = false;

  ArticleLearningLibraryWrapperDomain articleWrapper =
      ArticleLearningLibraryWrapperDomain(
    true,
    [],
  );

  Future<void> _onSetArticleLearningLibraryListingType(
    SetArticleLearningLibraryListingType event,
    Emitter<ArticleLearningLibraryListingState> emit,
  ) async {
    isSubsectionView = event.isSubSectionView;
  }

  Future<void> _onFetchArticleLearningLibrary(
    FetchArticleLearningLibraryListingEvent event,
    Emitter<ArticleLearningLibraryListingState> emit,
  ) async {
    emit(FetchingArticleLearningLibraryListingState());
    var offset = 0;
    switch (event.fetchStyle) {
      case FetchStyle.normal:
      case FetchStyle.pullToRefresh:
        articleWrapper = ArticleLearningLibraryWrapperDomain(
          true,
          [],
        );
      case FetchStyle.loadMore:
        offset = articleWrapper.articles.length;
    }

    final response = await _learningRepository.fetchArticlesLibrary(
        offset: offset, perPage: 10);
    response.when(success: (articlesResponse) {
      switch (event.fetchStyle) {
        case FetchStyle.normal:
        case FetchStyle.pullToRefresh:
          articleWrapper = articlesResponse.toDomain();
        case FetchStyle.loadMore:
          articleWrapper.hasMore = articlesResponse.pageMeta.hasMore;
          articleWrapper.articles.addAll(
              articlesResponse.articles.map((e) => e.toDomain()).toList());
      }
      if (isSubsectionView) {
        articleWrapper.addSeeMoreIfNecessary();
      }
      articleWrapper.sortArticles();
      emit(FetchedArticleLearningLibraryListingState());
    }, error: (error) {
      emit(ArticleLearningLibraryApiErrorState(error.toMessage()));
    });
  }
}
