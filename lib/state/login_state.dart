abstract class LoginState {}

class LoginInitState extends LoginState {}

class LoginProcessingState extends LoginState {}

class LoginErrorState extends LoginState {
  Exception error;

  LoginErrorState({this.error});
}
