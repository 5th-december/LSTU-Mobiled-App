// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discipline.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Discipline _$DisciplineFromJson(Map<String, dynamic> json) {
  return Discipline(
    id: json['id'] as String,
    name: json['name'] as String,
    chair: json['chair'] == null
        ? null
        : Chair.fromJson(json['chair'] as Map<String, dynamic>),
    category: json['category'] as String,
  );
}

Map<String, dynamic> _$DisciplineToJson(Discipline instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'chair': instance.chair,
      'category': instance.category,
    };
