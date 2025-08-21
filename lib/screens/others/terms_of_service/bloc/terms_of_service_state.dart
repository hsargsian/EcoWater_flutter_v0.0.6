part of 'terms_of_service_bloc.dart';

abstract class TermsOfServiceState {}

class TermsOfServiceIdleState extends TermsOfServiceState {}

class TermsOfServiceFetchingState extends TermsOfServiceState {}

class TermsOfServiceFetchedState extends TermsOfServiceState {
  TermsOfServiceFetchedState({required this.content});
  final String content;
}

class TermsOfServiceApiErrorState extends TermsOfServiceState {
  TermsOfServiceApiErrorState(this.errorMessage);
  final String errorMessage;
}
