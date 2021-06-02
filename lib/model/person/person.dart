import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'person.g.dart';

@JsonSerializable()
@HiveType(typeId: 2)
class Person {
  @JsonKey(name: 'uoid')
  @HiveField(0)
  final String id;

  @JsonKey(name: 'lname')
  @HiveField(1)
  final String surname;

  @JsonKey(name: 'fname')
  @HiveField(2)
  final String name;

  @HiveField(3)
  final String patronymic;

  @JsonKey(name: 'bday')
  @HiveField(4)
  final DateTime birthday;

  @HiveField(5)
  final String sex;

  @HiveField(6)
  final String phone;

  @HiveField(7)
  final String email;

  @HiveField(8)
  final String messenger;

  @HiveField(9)
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

  static Person fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);
  Map<String, dynamic> toJson() => _$PersonToJson(this);
}
