part of 'flask_personalization_bloc.dart';

abstract class FlaskPersonalizationState {}

class FlaskPersonalizationIdleState extends FlaskPersonalizationState {}

class FlaskFirmwareInfoFetchedState extends FlaskPersonalizationState {}

class FlaskFirmwareRetryingState extends FlaskPersonalizationState {
  FlaskFirmwareRetryingState(this.retryAttempt, this.maxAttempts);
  final int retryAttempt;
  final int maxAttempts;
}

class FlaskPersonalizationSetState extends FlaskPersonalizationState {}

class FlaskPersonalizationChangingState extends FlaskPersonalizationState {}

class FlaskPersonalizationUpdateCompleteState
    extends FlaskPersonalizationState {
  FlaskPersonalizationUpdateCompleteState(this.message, this.navigatesBack);
  final String message;
  final bool navigatesBack;
}

class FlaskPersonalizationApiErrorState extends FlaskPersonalizationState {
  FlaskPersonalizationApiErrorState(this.errorMessage);
  final String errorMessage;
}
