abstract class ComponentErrorHandler {
  final ComponentErrorHandler next;

  bool _isApplicable(dynamic errorSource);

  Exception apply(dynamic errorSource) {
    if (this._isApplicable(errorSource)) {
      return _handle(errorSource);
    } else {
      if (this.next == null) {
        return this._handleDefault(errorSource);
      }
      return next.apply(errorSource);
    }
  }

  Exception _handle(dynamic errorSource);

  Exception _handleDefault(dynamic errorSource) {
    return Exception('Undefined exception occurred');
  }

  ComponentErrorHandler({this.next});
}
