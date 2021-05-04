import 'package:lk_client/bloc/authentication_bloc.dart';
import 'package:lk_client/model/authentication/api_key.dart';

abstract class AuthenticationState {}

class AuthenticationUndefinedState extends AuthenticationState {}

class AuthenticationValidState extends AuthenticationState {
  ApiKey validToken;
  AuthenticationValidState(this.validToken);
}

class AuthenticationInvalidState extends AuthenticationState {
  ApiKey invalidToken;
  AuthenticationInvalidState(this.invalidToken);
}

class AuthenticationUnauthorizedState extends AuthenticationState {}

class AuthenticationProcessingState extends AuthenticationState {}

class AuthenticationIdentifiedState extends AuthenticationState {
  ApiKey identifyToken;
  AuthenticationIdentifiedState(this.identifyToken);
}
