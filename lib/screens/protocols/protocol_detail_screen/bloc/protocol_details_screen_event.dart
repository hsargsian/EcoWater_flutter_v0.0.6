part of 'protocol_details_screen_bloc.dart';

@immutable
sealed class ProtocolDetailsScreenEvent {}

class FetchProtocolDetailsEvent extends ProtocolDetailsScreenEvent {
  FetchProtocolDetailsEvent({required this.id, required this.protocolType});

  final String id;
  final String protocolType;
}

final class UpdateProtocolGoalEvent extends ProtocolDetailsScreenEvent {
  UpdateProtocolGoalEvent({required this.model});

  final CustomizeProtocolActiveRequestEntity model;
}

final class DeleteUserProtocolEvent extends ProtocolDetailsScreenEvent {
  DeleteUserProtocolEvent({required this.id});

  final String id;
}
