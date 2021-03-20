import 'package:lk_client/model/response/business_logic_error.dart';
import 'package:lk_client/model/response/student_identifier.dart';

abstract class RegisterState {}

class RegisterInitState extends RegisterState {}

class RegisterIdentifiedState extends RegisterState {
  StudentIdentifier identifier;

  RegisterIdentifiedState({this.identifier});
}

class RegisterProcessingState extends RegisterState {}

class RegisterErrorState extends RegisterState {
  BusinessLogicError error;

  RegisterErrorState({this.error});
}