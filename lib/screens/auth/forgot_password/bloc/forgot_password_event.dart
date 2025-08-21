import 'package:flutter/material.dart';

@immutable
abstract class ForgotPasswordEvent {}

class ForgotPasswordRequestEvent extends ForgotPasswordEvent {
  ForgotPasswordRequestEvent({required this.email});
  final String email;
}

class ValidateButtonEvent extends ForgotPasswordEvent {
  ValidateButtonEvent({required this.email});
  final String email;
}
