abstract class IdentifyState {}

class IdentifyInitState extends IdentifyState {}

class IdentifyProcessingState extends IdentifyState {}

class IdentifyErrorState extends IdentifyState {
  Exception error;

  IdentifyErrorState({this.error});
}
