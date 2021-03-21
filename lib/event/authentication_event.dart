import 'package:lk_client/model/response/jwt_token.dart';
import 'package:lk_client/model/response/student_identifier.dart';

abstract class AuthenticationEvent {}

class AppStartedEvent extends AuthenticationEvent {}

class IdentifiedEvent extends AuthenticationEvent {
  StudentIdentifier identifier;

  IdentifiedEvent({this.identifier});
}

class LoggedInEvent extends AuthenticationEvent {
  JwtToken apiToken;

  LoggedInEvent({this.apiToken});
}

class LoggedOutEvent extends AuthenticationEvent {}