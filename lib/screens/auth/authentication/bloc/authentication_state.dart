part of 'authentication_bloc.dart';

abstract class AuthenticationState {}

class AuthenticationIdleState extends AuthenticationState {}

class AuthenticationTokenExistState extends AuthenticationState {}

class AuthenticationAuthenticatedState extends AuthenticationState {}

class AuthenticationUnauthenticatedState extends AuthenticationState {}
