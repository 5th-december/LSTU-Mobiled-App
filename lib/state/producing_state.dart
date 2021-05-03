import 'package:lk_client/model/validatable.dart';

abstract class ProducingState<T> {
  final T data;
  ProducingState({this.data});
}

class ProducingInitState<T> extends ProducingState<T> {
  ProducingInitState({T initData}): super(data: initData);
}

class ProducingInvalidState<T> extends ProducingState<T> {
  ValidationErrorBox errorBox;
  ProducingInvalidState(this.errorBox, {T data}): super(data: data);
}

class ProducingLoadingState<T> extends ProducingState<T> {
  ProducingLoadingState({T data}): super(data: data);
}

class ProducingErrorState<T> extends ProducingState<T> {
  final Exception error;
  ProducingErrorState(this.error, {T data}): super(data: data);
}

class ProducingReadyState<T, R> extends ProducingState<T> {
  final R response;
  ProducingReadyState({this.response, T data}): super(data: data);
}
