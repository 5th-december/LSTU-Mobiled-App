import 'package:lk_client/model/response/business_logic_error.dart';

abstract class LoginState {}

class LoginInitState extends LoginState {}

class LoginProcessingState extends LoginState {}

class LoginErrorState extends LoginState {
  BusinessLogicError error;

  LoginErrorState({this.error});
}