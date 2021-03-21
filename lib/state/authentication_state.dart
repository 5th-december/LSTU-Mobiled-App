import 'package:lk_client/model/response/jwt_token.dart';
import 'package:lk_client/model/response/student_identifier.dart';

abstract class AuthenticationState {}

class AuthenticationUndefinedState extends AuthenticationState {}

class AuthenticationSuccessState extends AuthenticationState {
  JwtToken token;
  AuthenticationSuccessState(this.token);
}

class AuthenticationUnauthorizedState extends AuthenticationState {}

class AuthenticationProcessingState extends AuthenticationState {}

class AuthenticationIdentifiedState extends AuthenticationState {
  StudentIdentifier identifier;
  AuthenticationIdentifiedState(this.identifier);
}