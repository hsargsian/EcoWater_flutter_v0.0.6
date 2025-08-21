part of 'change_password_bloc.dart';

@immutable
abstract class ChangePasswordEvent {}

class ChangePasswordRequestEvent extends ChangePasswordEvent {
  ChangePasswordRequestEvent(
      {required this.currentPassword,
      required this.newPassword,
      required this.confirmPassword});
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;
}
