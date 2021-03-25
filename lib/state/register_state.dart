abstract class RegisterState {}

class RegisterInitState extends RegisterState {}

class RegisterProcessingState extends RegisterState {}

class RegisterErrorState extends RegisterState {
  Exception error;

  RegisterErrorState(this.error);
}
