import 'package:json_annotation/json_annotation.dart';
import 'package:lk_client/model/achievements/achievement.dart';
import 'package:lk_client/model/achievements/publication.dart';

part 'achievements_summary.g.dart';

@JsonSerializable()
class AchievementsSummary
{
  @JsonKey(name: 'achievements_total_count')
  final int achievementsTotalCount;

  @JsonKey(name: 'publications_total_count')
  final int publicationsTotalCount;

  @JsonKey(name: 'achievement_list')
  final List<Achievement> achievementList;

  @JsonKey(name: 'publications_list')
  final List<Publication> publicationsList;

  AchievementsSummary({
    this.achievementsTotalCount,
    this.publicationsTotalCount,
    this.achievementList,
    this.publicationsList
  });

  factory AchievementsSummary.fromJson(Map<String, dynamic> json) => _$AchievementsSummaryFromJson(json);
  Map<String, dynamic> toJson() => _$AchievementsSummaryToJson(this);
}