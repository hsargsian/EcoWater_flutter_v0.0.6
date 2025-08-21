part of 'terms_of_service_bloc.dart';

@immutable
abstract class TermsOfServiceEvent {}

class FetchTermsOfServiceEvent extends TermsOfServiceEvent {
  FetchTermsOfServiceEvent();
}
