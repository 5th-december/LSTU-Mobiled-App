import 'package:lk_client/model/response/student_identifier.dart';

abstract class RegisterEvent {}

class UserIdentifiedEvent extends RegisterEvent
{
  final StudentIdentifier studentIdentifier;

  UserIdentifiedEvent({this.studentIdentifier});
}

class RegisterButtonPressedEvent extends RegisterEvent {
  final String login;
  final String password;

  RegisterButtonPressedEvent({this.login, this.password});
}

class RegistrationCanceledEvent extends RegisterEvent {}