part of 'learning_screen_bloc.dart';

@immutable
abstract class LearningScreenEvent {}

class FetchBaseLearningUrlsEvent extends LearningScreenEvent {
  FetchBaseLearningUrlsEvent();
}
