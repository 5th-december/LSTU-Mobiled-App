import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lk_client/model/education/chair.dart';

part 'discipline.g.dart';

@JsonSerializable()
class Discipline
{
  final String id;

  final String name;

  final Chair chair;

  final String category;

  Discipline({this.id, this.name, this.chair, this.category});
  
  static Discipline fromJson(Map<String, dynamic> json) => _$DisciplineFromJson(json);
  Map<String, dynamic> toJson() => _$DisciplineToJson(this);
}