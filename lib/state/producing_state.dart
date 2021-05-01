import 'package:lk_client/model/validatable.dart';

abstract class ProducingState<T> {}

class ProducingInitState<T> extends ProducingState<T> {
  final T initData;
  ProducingInitState({this.initData});
}

class ProducingInvalidState<T> extends ProducingState<T> {
  ValidationErrorBox errorBox;
  ProducingInvalidState(this.errorBox);
}

class ProducingLoadingState<T> extends ProducingState<T> {}

class ProducingErrorState<T> extends ProducingState<T> {
  final Exception error;
  ProducingErrorState(this.error);
}

class ProducingReadyState<T> extends ProducingState<T> {
  final T response;
  ProducingReadyState({this.response});
}
