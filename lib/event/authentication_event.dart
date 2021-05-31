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

class TokenUpdateEvent extends AuthenticationEvent {
  ApiKey updatedToken;
  TokenUpdateEvent(this.updatedToken);
}

class TokenInvalidateEvent extends AuthenticationEvent {}

class TokenForcedUpdateEvent extends AuthenticationEvent {}

class LoggedOutEvent extends AuthenticationEvent {}
