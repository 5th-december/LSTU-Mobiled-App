import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'achievement.g.dart';

@JsonSerializable()
class Achievement {
  final String id;

  final String name;

  @JsonKey(name: 'achieved_date')
  final DateTime achievedDate;

  final String kind;

  final String type;

  Achievement(
      {@required this.id,
      @required this.name,
      this.achievedDate,
      this.kind,
      this.type});

  static Achievement fromJson(Map<String, dynamic> json) =>
      _$AchievementFromJson(json);
  Map<String, dynamic> toJson() => _$AchievementToJson(this);
}
