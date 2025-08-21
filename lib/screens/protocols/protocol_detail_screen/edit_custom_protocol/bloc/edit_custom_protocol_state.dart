part of 'edit_custom_protocol_bloc.dart';

@immutable
sealed class EditCustomProtocolState {}

final class EditCustomProtocolInitial extends EditCustomProtocolState {}

final class EditCustomProtocolLoading extends EditCustomProtocolState {}

final class EditCustomProtocolLoaded extends EditCustomProtocolState {
  EditCustomProtocolLoaded({required this.model});

  final CustomizeProtocolEntity model;
}

final class EditCustomProtocolFetchApiErrorState extends EditCustomProtocolState {
  EditCustomProtocolFetchApiErrorState(this.errorMessage);

  final String errorMessage;
}

final class SaveCustomProtocolLoaded extends EditCustomProtocolState {
  SaveCustomProtocolLoaded({required this.model});

  final CustomizeProtocolEntity model;
}
