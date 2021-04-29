import 'package:lk_client/error_handler/component_error_handler.dart';

class ApiSystemErrorHandler extends ComponentErrorHandler {
  @override
  bool isApplicable(dynamic errorSource) {
    return errorSource is Map<String, dynamic> &&
        errorSource.containsKey('type') &&
        errorSource['type'] == 'system' &&
        errorSource.containsKey('code') &&
        errorSource['code'] == 500 &&
        errorSource.containsKey('error') &&
        errorSource['error'] == 'ERR_SYSTEM' &&
        errorSource.containsKey('message');
  }

  @override
  Exception handle(dynamic errorSource) {
    return new ApiSystemException(errorSource['message']);
  }

  ApiSystemErrorHandler(ComponentErrorHandler next) : super(next: next);
}

class ApiSystemException implements Exception {
  final String message;

  ApiSystemException(this.message);
}
