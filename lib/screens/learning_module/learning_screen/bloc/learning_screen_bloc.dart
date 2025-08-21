import 'package:bloc/bloc.dart';
import 'package:echowater/core/domain/domain_models/learning_urls_domain.dart';
import 'package:echowater/core/domain/repositories/learning_repository.dart';
import 'package:flutter/material.dart';

part 'learning_screen_event.dart';
part 'learning_screen_state.dart';

class LearningScreenBloc
    extends Bloc<LearningScreenEvent, LearningScreenState> {
  LearningScreenBloc({required LearningRepository repository})
      : _repository = repository,
        super(NotificationScreenIdleState()) {
    on<FetchBaseLearningUrlsEvent>(_onFetchBaseLearningUrls);
  }
  final LearningRepository _repository;

  bool hasFetchedLearningUrls = false;
  late final LearningUrlsDomain learningUrlsDomain;
  Future<void> _onFetchBaseLearningUrls(
    FetchBaseLearningUrlsEvent event,
    Emitter<LearningScreenState> emit,
  ) async {
    emit(FetchingBaseLearningUrlsState());
    final response = await _repository.fetchLearningBaseUrls();
    response.when(success: (response) {
      hasFetchedLearningUrls = true;
      learningUrlsDomain = LearningUrlsDomain(response);
      emit(FetchedBaseLearningUrlsState());
    }, error: (error) {
      emit(LearningScreenApiErrorState(error.toMessage()));
    });
  }
}
