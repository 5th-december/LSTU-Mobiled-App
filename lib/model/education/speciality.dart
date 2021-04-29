import 'package:json_annotation/json_annotation.dart';

part 'speciality.g.dart';

@JsonSerializable()
class Speciality
{
  final String id;

  @JsonKey(name: 'spec_name')
  final String specName;

  @JsonKey(name: 'spec_name_abbr')
  final String specNameAbbr;

  final String qualification;

  final String form;

  Speciality({this.id, this.specName, this.specNameAbbr, this.qualification, this.form});

  factory Speciality.fromJson(Map<String, dynamic> json) => _$SpecialityFromJson(json);
  Map<String, dynamic> toJson() => _$SpecialityToJson(this);
}