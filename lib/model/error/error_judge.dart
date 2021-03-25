import 'package:lk_client/model/error/component_error_handler.dart';

class ErrorJudge extends ComponentErrorHandler {
  @override
  bool _isApplicable(dynamic errorSource) {
    return errorSource is Exception;
  }

  @override
  Exception _handle(dynamic errorSource) {
    return errorSource;
  }

  ErrorJudge(ComponentErrorHandler next) : super(next: next);
}
