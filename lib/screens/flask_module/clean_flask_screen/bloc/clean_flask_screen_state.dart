part of 'clean_flask_screen_bloc.dart';

abstract class CleanFlaskScreenState {}

class CleanFlaskScreenIdleState extends CleanFlaskScreenState {}

class UpdatingCleanFlaskLogState extends CleanFlaskScreenState {}

class UpdatedCleanFlaskLogState extends CleanFlaskScreenState {
  UpdatedCleanFlaskLogState(this.message);
  final String message;
}

class CleanFlaskScreenApiErrorState extends CleanFlaskScreenState {
  CleanFlaskScreenApiErrorState(this.errorMessage);
  final String errorMessage;
}
