abstract class AuthenticationState {}

class AuthenticationUndefinedState extends AuthenticationState {}

class AuthenticationSuccessState extends AuthenticationState {}

class AuthenticationUnauthorizedState extends AuthenticationState {}

class AuthenticationProcessingState extends AuthenticationState {}