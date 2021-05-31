import 'package:lk_client/model/authentication/api_key.dart';

abstract class AuthenticationState {}

abstract class Tokenized {
  ApiKey token;
  Tokenized(this.token);
}

class AuthenticationUndefinedState implements AuthenticationState {}

class AuthenticationValidState extends Tokenized
    implements AuthenticationState {
  AuthenticationValidState(ApiKey validToken) : super(validToken);
}

class AuthenticationInvalidState extends Tokenized
    implements AuthenticationState {
  AuthenticationInvalidState(ApiKey invalidToken) : super(invalidToken);
}

class AuthenticationUnauthorizedState implements AuthenticationState {}

class AuthenticationProcessingState implements AuthenticationState {}

class AuthenticationIdentifiedState extends Tokenized
    implements AuthenticationState {
  AuthenticationIdentifiedState(ApiKey identifiedToken)
      : super(identifiedToken);
}
