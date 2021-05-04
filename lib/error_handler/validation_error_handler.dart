import 'package:flutter/foundation.dart';
import 'package:lk_client/error_handler/component_error_handler.dart';

class ValidationErrorHandler extends ComponentErrorHandler {
  @override
  bool isApplicable(dynamic errorSource) {
    return errorSource is Map<String, dynamic> &&
        errorSource.containsKey('code') &&
        errorSource['code'] == 400 &&
        errorSource.containsKey('error') &&
        errorSource['error'] == 'ERR_VALIDATION';
  }

  @override
  Exception handle(dynamic errorSource) {
    return new ValidationException(
        errorMessages: errorSource['details'], message: errorSource['message']);
  }

  ValidationErrorHandler(ComponentErrorHandler next) : super(next: next);
}

class ValidationException implements Exception {
  final message;
  final errorMessages;

  ValidationException({this.message, @required this.errorMessages});
}
