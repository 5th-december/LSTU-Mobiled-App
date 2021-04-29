import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'faculty.g.dart';

@JsonSerializable()
class Faculty
{
  final String id;

  @JsonKey(name: 'fac_code')
  final String facCode;

  @JsonKey(name: 'fac_name')
  final String facName;

  Faculty({this.id, this.facCode, this.facName});

  factory Faculty.fromJson(Map<String, dynamic> json) => _$FacultyFromJson(json);
  Map<String, dynamic> toJson() => _$FacultyToJson(this);
}