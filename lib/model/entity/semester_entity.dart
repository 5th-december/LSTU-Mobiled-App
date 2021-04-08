import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'semester_entity.g.dart';

@JsonSerializable()
class SemesterEntity {
  @JsonKey(name: 'oid')
  final String id;

  @JsonKey(name: 'year')
  final String year;

  @JsonKey(name: 'season')
  final String season;

  SemesterEntity(
      {@required this.id, @required this.year, @required this.season});

  factory SemesterEntity.fromJson(Map<String, dynamic> json) =>
      _$SemesterEntityFromJson(json);
  Map<String, dynamic> toJson() => _$SemesterEntityToJson(this);
}
