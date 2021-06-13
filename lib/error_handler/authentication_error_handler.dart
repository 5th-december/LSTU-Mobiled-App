import 'package:lk_client/error_handler/component_error_handler.dart';

class AuthenticationErrorHandler extends ComponentErrorHandler {
  @override
  bool isApplicable(dynamic errorSource) {
    return errorSource is Map<String, dynamic> &&
        errorSource.containsKey('code') &&
        errorSource['code'] == 401;
  }

  @override
  Exception handle(dynamic errorSource) {
    return new AuthenticationException(message: errorSource['message']);
  }

  AuthenticationErrorHandler(ComponentErrorHandler next) : super(next: next);
}

class AuthenticationException implements Exception {
  final String message;
  AuthenticationException({this.message});
}
