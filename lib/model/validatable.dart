import 'package:flutter/foundation.dart';

abstract class Validatable {
  ValidationErrorBox validate() {
    throw new Exception('Not implemented');
  }
}

class ValidationError {
  final String path;
  final String message;

  ValidationError({@required this.path, @required this.message});
}

class ValidationErrorBox {
  final List<ValidationError> _errors;

  ValidationErrorBox(this._errors);

  bool hasErrors() => this._errors.length != 0;

  ValidationError getFirstForField(String fieldName) {
    return this._errors.firstWhere((element) => element.path == fieldName, orElse: () => null);
  }

  List<ValidationError> getAllForField(String fieldName) {
    return this._errors.where((element) => element.path == fieldName);
  }

  List<ValidationError> getAll() => this._errors;
}
