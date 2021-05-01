import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'person.g.dart';

@JsonSerializable()
class Person {
  @JsonKey(name: 'uoid')
  final String id;

  @JsonKey(name: 'lname')
  final String surname;

  @JsonKey(name: 'fname')
  final String name;

  final String patronymic;

  @JsonKey(name: 'bday')
  final DateTime birthday;

  final String sex;

  final String phone;

  final String email;

  final String messenger;

  final String post;

  Person(
      {@required this.id,
      @required this.surname,
      @required this.name,
      this.patronymic,
      this.birthday,
      this.sex,
      this.phone,
      this.email,
      this.messenger,
      this.post});

  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);
  Map<String, dynamic> toJson() => _$PersonToJson(this);
}
