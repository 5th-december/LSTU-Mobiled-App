import 'package:lk_client/model/request/user_login_credentials.dart';

abstract class LoginEvent {}

class LoginButtonPressedEvent extends LoginEvent
{
  UserLoginCredentials userLoginCredentials;

  LoginButtonPressedEvent({this.userLoginCredentials});
}