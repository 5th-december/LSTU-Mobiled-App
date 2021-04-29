// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'achievements_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AchievementsSummary _$AchievementsSummaryFromJson(Map<String, dynamic> json) {
  return AchievementsSummary(
    achievementsTotalCount: json['achievements_total_count'] as int,
    publicationsTotalCount: json['publications_total_count'] as int,
    achievementList: (json['achievement_list'] as List)
        ?.map((e) =>
            e == null ? null : Achievement.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    publicationsList: (json['publications_list'] as List)
        ?.map((e) =>
            e == null ? null : Publication.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$AchievementsSummaryToJson(
        AchievementsSummary instance) =>
    <String, dynamic>{
      'achievements_total_count': instance.achievementsTotalCount,
      'publications_total_count': instance.publicationsTotalCount,
      'achievement_list': instance.achievementList,
      'publications_list': instance.publicationsList,
    };
