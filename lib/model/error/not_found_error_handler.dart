import 'dart:html';

import 'package:lk_client/model/error/component_error_handler.dart';

class NotFoundErrorHandler extends ComponentErrorHandler {
  @override
  bool _isApplicable(dynamic errorSource) {
    return errorSource is Map<String, dynamic> &&
        errorSource.containsKey('code') &&
        errorSource['code'] == HttpStatus.notFound &&
        errorSource.containsKey('error') &&
        errorSource['error'] == 'ERR_NOTFOUND' &&
        errorSource.containsKey('generic_message') &&
        errorSource.containsKey('error_messages');
  }

  @override
  Exception _handle(dynamic errorSource) {
    return new NotFoundException(
        errorSource['generic_message'], errorSource['error_messages']);
  }

  NotFoundErrorHandler(ComponentErrorHandler next) : super(next: next);
}

class NotFoundException implements Exception {
  final String message;
  List<String> notFoundItems;

  NotFoundException(this.message, Map<String, String> items) {
    this.notFoundItems = items.values;
  }
}
