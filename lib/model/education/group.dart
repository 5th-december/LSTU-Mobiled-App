import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lk_client/model/education/chair.dart';
import 'package:lk_client/model/education/speciality.dart';

part 'group.g.dart';

@JsonSerializable()
class Group
{
  final String id;

  final String name;

  final Chair chair;

  final DateTime admission;

  final DateTime graduation;

  final Speciality speciality;

  Group({this.id, this.name, this.chair, this.admission, this.graduation, this.speciality});

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);
  Map<String, dynamic> toJson() => _$GroupToJson(this);
}