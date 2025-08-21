part of 'protocols_listing_bloc.dart';

abstract class ProtocolsListingState {}

class ProtocolsListingIdleState extends ProtocolsListingState {}

class FetchingProtocolsListingState extends ProtocolsListingState {}

class FetchedProtocolsListingState extends ProtocolsListingState {
  FetchedProtocolsListingState();
}

class ProtocolsFetchApiErrorState extends ProtocolsListingState {
  ProtocolsFetchApiErrorState(this.errorMessage);
  final String errorMessage;
}
