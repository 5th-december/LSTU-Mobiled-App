import 'package:lk_client/error_handler/component_error_handler.dart';

class AccessDeniedErrorHandler extends ComponentErrorHandler {
  @override
  bool isApplicable(dynamic errorSource) {
    return errorSource is Map<String, dynamic> &&
        errorSource.containsKey('code') &&
        errorSource['code'] == 403 &&
        errorSource.containsKey('error') &&
        errorSource['error'] == 'ERR_DENIED';
  }

  @override
  Exception handle(dynamic errorSource) {
    return new AccessDeniedException(message: errorSource['message']);
  }

  AccessDeniedErrorHandler(ComponentErrorHandler next) : super(next: next);
}

class AccessDeniedException implements Exception {
  String message;

  AccessDeniedException({this.message});
}
