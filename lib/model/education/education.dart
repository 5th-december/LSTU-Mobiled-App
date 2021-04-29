import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lk_client/model/education/group.dart';

part 'education.g.dart';

@JsonSerializable()
class Education {
  final String id;

  final String status;

  final Group group;

  Education({this.id, this.status, this.group});

  static Education fromJson(Map<String, dynamic> json) =>
      _$EducationFromJson(json);
  Map<String, dynamic> toJson() => _$EducationToJson(this);
}


