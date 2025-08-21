part of 'learning_screen_bloc.dart';

abstract class LearningScreenState {}

class NotificationScreenIdleState extends LearningScreenState {}

class FetchingBaseLearningUrlsState extends LearningScreenState {}

class FetchedBaseLearningUrlsState extends LearningScreenState {
  FetchedBaseLearningUrlsState();
}

class LearningScreenApiErrorState extends LearningScreenState {
  LearningScreenApiErrorState(this.errorMessage);
  final String errorMessage;
}
