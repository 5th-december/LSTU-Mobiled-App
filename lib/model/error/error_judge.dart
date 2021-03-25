import 'package:lk_client/model/error/component_error_handler.dart';

class ErrorJudge extends ComponentErrorHandler {
  @override
  bool isApplicable(dynamic errorSource) {
    return errorSource is Exception;
  }

  @override
  Exception handle(dynamic errorSource) {
    return errorSource;
  }

  ErrorJudge(ComponentErrorHandler next) : super(next: next);
}
