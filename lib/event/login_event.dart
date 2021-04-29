import 'package:lk_client/model/authentication/login_credentials.dart';

abstract class LoginEvent {}

class LoginButtonPressedEvent extends LoginEvent {
  LoginCredentials userLoginCredentials;

  LoginButtonPressedEvent({this.userLoginCredentials});
}
