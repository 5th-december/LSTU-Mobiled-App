import 'dart:html';

import 'package:lk_client/model/error/component_error_handler.dart';

class DuplicateErrorHandler extends ComponentErrorHandler {
  @override
  bool _isApplicable(dynamic errorSource) {
    return errorSource is Map<String, dynamic> &&
        errorSource.containsKey('code') &&
        errorSource['code'] == HttpStatus.badRequest &&
        errorSource.containsKey('error') &&
        errorSource['error'] == 'ERR_DUPLICATE' &&
        errorSource.containsKey('generic_message') &&
        errorSource.containsKey('error_messages');
  }

  @override
  Exception _handle(dynamic errorSource) {
    return new DuplicateException(
        errorSource['generic_message'], errorSource['error_messages']);
  }

  DuplicateErrorHandler(ComponentErrorHandler next) : super(next: next);
}

class DuplicateException implements Exception {
  String message;
  List<String> duplicates;

  DuplicateException(this.message, Map<String, String> duplicateValues) {
    this.duplicates = duplicateValues.values;
  }
}
