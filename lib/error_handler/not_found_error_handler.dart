import 'package:lk_client/error_handler/component_error_handler.dart';

class NotFoundErrorHandler extends ComponentErrorHandler {
  @override
  bool isApplicable(dynamic errorSource) {
    return errorSource is Map<String, dynamic> &&
        errorSource.containsKey('code') &&
        errorSource['code'] == 404 &&
        errorSource.containsKey('error') &&
        errorSource['error'] == 'ERR_NOT_FOUND';
  }

  @override
  Exception handle(dynamic errorSource) {
    return new NotFoundException(message: errorSource['message']);
  }

  NotFoundErrorHandler(ComponentErrorHandler next) : super(next: next);
}

class NotFoundException implements Exception {
  final String message;
  NotFoundException({this.message});
}
