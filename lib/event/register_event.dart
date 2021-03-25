abstract class RegisterEvent {}

class RegisterButtonPressedEvent extends RegisterEvent {
  final String login;
  final String password;

  RegisterButtonPressedEvent({this.login, this.password});
}

class RegistrationCanceledEvent extends RegisterEvent {}