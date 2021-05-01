import 'package:json_annotation/json_annotation.dart';
import 'package:lk_client/model/validatable.dart';
import 'package:validators/validators.dart';

part 'contacts.g.dart';

@JsonSerializable()
class Contacts extends Validatable {
  final String phone;

  final String email;

  final String messenger;

  Contacts({this.phone, this.email, this.messenger});

  @override
  ValidationErrorBox validate() {
    List<ValidationError> errors = [];

    errors.addAll(this._validatePhone());
    errors.addAll(this._validateEmail());
    errors.addAll(this._validateMessenger());

    return ValidationErrorBox(errors);
  }

  List<ValidationError> _validatePhone() {
    List<ValidationError> errors = [];
    if (this.phone == null || this.phone == '') {
      return errors;
    }
    if (!matches(this.phone, r'^\+7\(\d{3}\)\d{3}-\d{2}-\d{2}$')) {
      errors.add(new ValidationError(
          path: 'phone',
          message:
              'Значение номера телефона должно быть указано в формате +7(ХХХ)ХХХ-ХХ-ХХ'));
    }
    return errors;
  }

  List<ValidationError> _validateEmail() {
    List<ValidationError> errors = [];
    if (this.email == null || this.email == '') {
      return errors;
    }
    if (isEmail(this.email)) {
      errors.add(new ValidationError(
          path: 'email',
          message:
              'Указанный адрес не является действительным адресом e-mail'));
    }
    return errors;
  }

  List<ValidationError> _validateMessenger() {
    List<ValidationError> errors = [];
    if (this.messenger == null || this.messenger == '') {
      return errors;
    }
    if (this.messenger.length > 50) {
      errors.add(new ValidationError(
          path: 'messenger', message: 'Длина не должна превышать 50 символов'));
    }
    return errors;
  }

  factory Contacts.fromJson(Map<String, dynamic> json) =>
      _$ContactsFromJson(json);
  Map<String, dynamic> toJson() => _$ContactsToJson(this);
}
