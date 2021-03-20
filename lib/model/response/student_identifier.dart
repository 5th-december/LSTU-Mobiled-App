import 'package:json_annotation/json_annotation.dart';

part 'student_identifier.g.dart';

@JsonSerializable()
class StudentIdentifier
{
  final String temporaryLoggingId;
  final String name;
  final int validUntil;

  StudentIdentifier({this.temporaryLoggingId, this.name, this.validUntil});

  factory StudentIdentifier.fromJson(Map<String, dynamic> json) => _$StudentIdentifierFromJson(json);
  Map<String, dynamic> toJson() => _$StudentIdentifierToJson(this);
}