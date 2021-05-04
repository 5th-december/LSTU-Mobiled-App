import 'package:lk_client/error_handler/component_error_handler.dart';

class DuplicateErrorHandler extends ComponentErrorHandler {
  @override
  bool isApplicable(dynamic errorSource) {
    return errorSource is Map<String, dynamic> &&
        errorSource.containsKey('code') &&
        errorSource['code'] == 400 &&
        errorSource.containsKey('error') &&
        errorSource['error'] == 'ERR_DUPLICATE';
  }

  @override
  Exception handle(dynamic errorSource) {
    return new DuplicateException(message: errorSource['message']);
  }

  DuplicateErrorHandler(ComponentErrorHandler next) : super(next: next);
}

class DuplicateException implements Exception {
  String message;

  DuplicateException({this.message});
}
