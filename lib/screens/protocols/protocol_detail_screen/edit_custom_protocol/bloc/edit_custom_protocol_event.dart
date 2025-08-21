part of 'edit_custom_protocol_bloc.dart';

@immutable
sealed class EditCustomProtocolEvent {}

final class EditCustomProtocolEventFetch extends EditCustomProtocolEvent {
  EditCustomProtocolEventFetch({required this.id});

  final String id;
}

final class ResetCustomProtocolEvent extends EditCustomProtocolEvent {
  ResetCustomProtocolEvent({required this.model});

  final ProtocolDetailsEntity model;
}

final class SaveCustomProtocolEvent extends EditCustomProtocolEvent {
  SaveCustomProtocolEvent({required this.id, required this.model, this.isFromBlankTemplate = false});

  final String id;
  final CustomizeProtocolEntity model;
  final bool isFromBlankTemplate;
}
