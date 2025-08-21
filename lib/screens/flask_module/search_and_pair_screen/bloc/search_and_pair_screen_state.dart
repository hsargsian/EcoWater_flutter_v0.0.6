part of 'search_and_pair_screen_bloc.dart';

abstract class SearchAndPairScreenState {}

class SearchAndPairScreenIdleState extends SearchAndPairScreenState {}

class AddingNewFlaskState extends SearchAndPairScreenState {}

class AddedNewFlaskState extends SearchAndPairScreenState {
  AddedNewFlaskState(this.flask);
  final FlaskDomain flask;
}

class SearchAndPairScreenApiErrorState extends SearchAndPairScreenState {
  SearchAndPairScreenApiErrorState(this.errorMessage);
  final String errorMessage;
}
