import 'package:lk_client/model/response/api_key.dart';

abstract class AuthenticationEvent {}

class AppStartedEvent extends AuthenticationEvent {}

class IdentifiedEvent extends AuthenticationEvent {
  ApiKey apiKey;

  IdentifiedEvent({this.apiKey});
}

class LoggedInEvent extends AuthenticationEvent {
  ApiKey apiKey;

  LoggedInEvent({this.apiKey});
}

class LoggedOutEvent extends AuthenticationEvent {}
