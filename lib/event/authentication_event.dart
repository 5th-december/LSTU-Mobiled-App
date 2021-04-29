import 'package:lk_client/model/authentication/api_key.dart';

abstract class AuthenticationEvent {}

class AppStartedEvent extends AuthenticationEvent {}

class IdentifiedEvent extends AuthenticationEvent {
  ApiKey identificationKey;
  IdentifiedEvent(this.identificationKey);
}

class TokenValidateEvent extends AuthenticationEvent {
  ApiKey validToken;
  TokenValidateEvent(this.validToken);
}

class TokenInvalidateEvent extends AuthenticationEvent {
  ApiKey invalidToken;
  TokenInvalidateEvent(this.invalidToken);
}

class LoggedOutEvent extends AuthenticationEvent {}
