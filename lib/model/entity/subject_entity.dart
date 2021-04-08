import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'subject_entity.g.dart';

@JsonSerializable()
class SubjectEntity
{
  @JsonKey(name: 'subject_id')
  String subjectId;

  @JsonKey(name: 'subject_name')
  String subjectName;

  @JsonKey(name: 'chair_name')
  String chairName;

  SubjectEntity({
    @required this.subjectId, 
    @required this.subjectName,
    this.chairName
  });
  
  factory SubjectEntity.fromJson(Map<String, dynamic> json) => _$SubjectEntityFromJson(json);
  Map<String, dynamic> toJson() => _$SubjectEntityToJson(this);
}