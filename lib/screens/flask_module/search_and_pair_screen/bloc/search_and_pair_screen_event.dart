part of 'search_and_pair_screen_bloc.dart';

@immutable
abstract class SearchAndPairScreenEvent {}

class AddNewFlaskEvent extends SearchAndPairScreenEvent {
  AddNewFlaskEvent();
}

class SetFlaskToPairEvent extends SearchAndPairScreenEvent {
  SetFlaskToPairEvent(this.appBleModel, this.name);
  final AppBleModel appBleModel;
  final String name;
}
