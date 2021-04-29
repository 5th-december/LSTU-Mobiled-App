import 'package:lk_client/error_handler/component_error_handler.dart';

class StubErrorHandler extends ComponentErrorHandler {
  @override
  bool isApplicable(dynamic errorSource) {
    return true;
  }

  @override
  Exception handle(dynamic errorSource) {
    return new Exception(
        'An unexpected error occurred. Rerun application and try again');
  }

  StubErrorHandler() : super(next: null);
}
