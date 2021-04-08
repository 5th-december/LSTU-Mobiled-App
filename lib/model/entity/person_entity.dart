import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'person_entity.g.dart';

@JsonSerializable()
class PersonEntity {
  @JsonKey(name: 'uoid')
  final String id;

  @JsonKey(name: 'lname')
  final String surname;

  @JsonKey(name: 'fname')
  final String name;

  @JsonKey(name: 'partonymic')
  final String partonymic;

  @JsonKey(name: 'bday', fromJson: _dateFromJson, toJson: _dateToJson)
  final DateTime birthday;

  @JsonKey(name: 'sex')
  final String sex;

  @JsonKey(name: 'phone')
  final String phone;

  @JsonKey(name: 'email')
  final String email;

  @JsonKey(name: 'messenger')
  final String messenger;

  PersonEntity(
      {@required this.id,
      @required this.surname,
      @required this.name,
      this.partonymic,
      this.birthday,
      this.sex,
      this.phone,
      this.email,
      this.messenger});

  factory PersonEntity.fromJson(Map<String, dynamic> json) =>
      _$PersonEntityFromJson(json);
  Map<String, dynamic> toJson() => _$PersonEntityToJson(this);
}

final _dateFormatter = DateFormat('d.M.yyyy');
DateTime _dateFromJson(String date) => _dateFormatter.parse(date);
String _dateToJson(DateTime date) => _dateFormatter.format(date);
