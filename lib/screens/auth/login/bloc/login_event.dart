part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class LogInRequestEvent extends LoginEvent {
  LogInRequestEvent({required this.email, required this.password});
  final String email;
  final String password;
}

class FetchUserInformationEvent extends LoginEvent {
  FetchUserInformationEvent();
}

class FormFieldValueChangedEvent extends LoginEvent {
  FormFieldValueChangedEvent({required this.email, required this.password});
  final String email;
  final String password;
}
