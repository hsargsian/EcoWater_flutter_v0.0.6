part of 'protocol_details_screen_bloc.dart';

@immutable
sealed class ProtocolDetailsScreenState {}

final class ProtocolDetailsScreenInitial extends ProtocolDetailsScreenState {}

class FetchingDetailsState extends ProtocolDetailsScreenState {}

class FetchedProtocolDetailsState extends ProtocolDetailsScreenState {
  FetchedProtocolDetailsState(this.model, {this.isRefreshedPage = false});

  final ProtocolDetailsEntity model;
  final bool isRefreshedPage;
}

class ProtocolDetailsFetchApiErrorState extends ProtocolDetailsScreenState {
  ProtocolDetailsFetchApiErrorState(this.errorMessage);

  final String errorMessage;
}

class DeleteUserProtocolState extends ProtocolDetailsScreenState {
  DeleteUserProtocolState(this.message);

  final ApiSuccessMessageResponseEntity message;
}
