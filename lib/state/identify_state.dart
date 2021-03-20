import 'package:lk_client/model/response/business_logic_error.dart';

abstract class IdentifyState {}

class IdentifyInitState extends IdentifyState {}

class IdentifyProcessingState extends IdentifyState {}

class IdentifyErrorState extends IdentifyState {
  BusinessLogicError error;

  IdentifyErrorState({this.error});
}