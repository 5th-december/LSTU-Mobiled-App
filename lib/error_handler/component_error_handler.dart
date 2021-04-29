import 'package:flutter/foundation.dart';

abstract class ComponentErrorHandler {
  final ComponentErrorHandler next;

  @protected
  bool isApplicable(dynamic errorSource);

  Exception apply(dynamic errorSource) {
    if (this.isApplicable(errorSource)) {
      return handle(errorSource);
    } else {
      if (this.next == null) {
        return this.handleDefault(errorSource);
      }
      return next.apply(errorSource);
    }
  }

  @protected
  Exception handle(dynamic errorSource);

  Exception handleDefault(dynamic errorSource) {
    return Exception('Undefined exception occurred');
  }

  ComponentErrorHandler({this.next});
}
