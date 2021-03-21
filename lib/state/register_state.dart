import 'package:lk_client/model/response/business_logic_error.dart';

abstract class RegisterState {}

class RegisterInitState extends RegisterState {}

class RegisterProcessingState extends RegisterState {}

class RegisterErrorState extends RegisterState {
  BusinessLogicError error;

  RegisterErrorState({this.error});
}