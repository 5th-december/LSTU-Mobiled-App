import 'package:lk_client/model/error/component_error_handler.dart';

class ValidationErrorHandler extends ComponentErrorHandler {
  @override
  bool isApplicable(dynamic errorSource) {
    return errorSource is Map<String, dynamic> &&
        errorSource.containsKey('code') &&
        errorSource['code'] == 400 &&
        errorSource.containsKey('error') &&
        errorSource['error'] == 'ERR_VALIDATION' &&
        errorSource.containsKey('generic_message') &&
        errorSource.containsKey('error_messages');
  }

  @override
  Exception handle(dynamic errorSource) {
    return new ValidationException(
        errorSource['generic_message'], errorSource['error_messages']);
  }

  ValidationErrorHandler(ComponentErrorHandler next) : super(next: next);
}

class ValidationException implements Exception {
  final message;
  final errorMessages;

  ValidationException(this.message, this.errorMessages);
}
