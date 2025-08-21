part of 'my_flasks_listing_screen_bloc.dart';

@immutable
abstract class MyFlasksListingScreenEvent {}

class FetchMyFlasksEvent extends MyFlasksListingScreenEvent {
  FetchMyFlasksEvent(this.fetchStyle);
  final FetchStyle fetchStyle;
}

class DeleteMyFlaskEvent extends MyFlasksListingScreenEvent {
  DeleteMyFlaskEvent(this.flask);
  final FlaskDomain flask;
}

class TurnOnBluetoothEvent extends MyFlasksListingScreenEvent {
  TurnOnBluetoothEvent({required this.isGoToNextPage, this.flask});
  final bool isGoToNextPage;
  final FlaskDomain? flask;
}
