import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/foundation.dart';

part 'education_entity.g.dart';

@JsonSerializable()
class EducationEntity {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'status')
  final String status;

  @JsonKey(name: 'start', fromJson: _dateFromJson, toJson: _dateToJson)
  final DateTime start;

  @JsonKey(name: 'end', fromJson: _dateFromJson, toJson: _dateToJson)
  final DateTime end;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'form')
  final String form;

  @JsonKey(name: 'qualification')
  final String qualification;

  EducationEntity(
      {@required this.id,
      this.status,
      this.start,
      this.end,
      @required this.name,
      this.form,
      this.qualification});

  factory EducationEntity.fromJson(Map<String, dynamic> json) =>
      _$EducationEntityFromJson(json);
  Map<String, dynamic> toJson() => _$EducationEntityToJson(this);
}

final _dateFormatter = DateFormat('M.yyyy');
DateTime _dateFromJson(String date) => _dateFormatter.parse(date);
String _dateToJson(DateTime date) => _dateFormatter.format(date);
