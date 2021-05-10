import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lk_client/model/education/faculty.dart';
import 'package:lk_client/model/person/person.dart';

part 'chair.g.dart';

@JsonSerializable()
class Chair {
  final String id;

  @JsonKey(name: 'chair_name')
  final String chairName;

  @JsonKey(name: 'chair_name_abbr')
  final String chairNameAbbr;

  final Faculty faculty;

  final Person chairman;

  Chair(
      {@required this.id,
      @required this.chairName,
      this.chairNameAbbr,
      this.faculty,
      this.chairman});

  factory Chair.fromJson(Map<String, dynamic> json) => _$ChairFromJson(json);
  Map<String, dynamic> toJson() => _$ChairToJson(this);
}
