part of 'clean_flask_screen_bloc.dart';

@immutable
abstract class CleanFlaskScreenEvent {}

class AddFlaskCleanLogEvent extends CleanFlaskScreenEvent {
  AddFlaskCleanLogEvent({required this.flask});
  final FlaskDomain flask;
}
