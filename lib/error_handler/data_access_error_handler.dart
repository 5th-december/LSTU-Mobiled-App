import 'package:lk_client/error_handler/component_error_handler.dart';

class DataAccessErrorHandler extends ComponentErrorHandler {
  @override
  bool isApplicable(dynamic errorSource) {
    return errorSource is Map<String, dynamic> &&
        errorSource.containsKey('code') &&
        errorSource['code'] == 500 &&
        errorSource.containsKey('error') &&
        errorSource['error'] == 'ERR_DATA_ACCESS';
  }

  @override
  Exception handle(dynamic errorSource) {
    return new DataAccessException();
  }

  DataAccessErrorHandler(ComponentErrorHandler next) : super(next: next);
}

class DataAccessException implements Exception {}
