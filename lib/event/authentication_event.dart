import 'package:lk_client/model/response/jwt_token.dart';

abstract class AuthenticationEvent {}

class AppStartedEvent extends AuthenticationEvent {}

class LoggedInEvent extends AuthenticationEvent {
  JwtToken apiToken;

  LoggedInEvent({this.apiToken});
}

class LoggedOutEvent extends AuthenticationEvent {}