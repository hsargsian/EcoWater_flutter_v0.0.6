part of 'signup_bloc.dart';

@immutable
abstract class SignUpEvent {}

class SignUpRequestEvent extends SignUpEvent {
  SignUpRequestEvent(this.name, this.lastName, this.email, this.password, this.confirmPassword, this.phoneNumber,
      this.countryName, this.countryCode);

  final String name;
  final String lastName;
  final String email;
  final String password;
  final String confirmPassword;
  final String phoneNumber;
  final String countryName;
  final String countryCode;
}

class LogInRequestEvent extends SignUpEvent {
  LogInRequestEvent({required this.email, required this.password});

  final String email;
  final String password;
}

class FetchUserInformationEvent extends SignUpEvent {
  FetchUserInformationEvent();
}

class FetchSystemAccessEvent extends SignUpEvent {}
