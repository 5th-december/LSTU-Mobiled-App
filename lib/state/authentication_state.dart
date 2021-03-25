import 'package:lk_client/model/response/api_key.dart';

abstract class AuthenticationState {}

class AuthenticationUndefinedState extends AuthenticationState {}

class AuthenticationSuccessState extends AuthenticationState {
  ApiKey token;
  AuthenticationSuccessState(this.token);
}

class AuthenticationUnauthorizedState extends AuthenticationState {}

class AuthenticationProcessingState extends AuthenticationState {}

class AuthenticationIdentifiedState extends AuthenticationState {}
