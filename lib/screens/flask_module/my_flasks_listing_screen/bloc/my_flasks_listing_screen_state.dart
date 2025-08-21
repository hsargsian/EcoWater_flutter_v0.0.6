part of 'my_flasks_listing_screen_bloc.dart';

abstract class MyFlasksListingScreenState {}

class MyFlasksListingScreenIdleState extends MyFlasksListingScreenState {}

class FetchingMyFlasksState extends MyFlasksListingScreenState {}

class FlaskDeletedState extends MyFlasksListingScreenState {}

class FetchedMyFlasksState extends MyFlasksListingScreenState {}

class MyFlasksScreenApiErrorState extends MyFlasksListingScreenState {
  MyFlasksScreenApiErrorState(this.errorMessage);
  final String errorMessage;
}

class StartFlaskSuccessState extends MyFlasksListingScreenState {
  StartFlaskSuccessState(this.message);
  final String message;
}

class TurnOnBluetoothState extends MyFlasksListingScreenState {
  TurnOnBluetoothState(
      {required this.isGoToNextPage, this.flask, this.errorMessage});
  final bool isGoToNextPage;
  final FlaskDomain? flask;
  final String? errorMessage;
}
