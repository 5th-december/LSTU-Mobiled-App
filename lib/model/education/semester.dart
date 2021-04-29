import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'semester.g.dart';

@JsonSerializable()
class Semester 
{
  final String id;

  final String year;

  final String season;

  Semester({@required this.id, @required this.year, @required this.season});

  static Semester fromJson(Map<String, dynamic> json) =>
      _$SemesterFromJson(json);
  Map<String, dynamic> toJson() => _$SemesterToJson(this);
}
