// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'publication.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Publication _$PublicationFromJson(Map<String, dynamic> json) {
  return Publication(
    id: json['id'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    published: json['published'] as String,
    pubType: json['pub_type'] as String,
    pubForm: json['pub_form'] as String,
    pubFormValue: json['pub_form_value'] as String,
  );
}

Map<String, dynamic> _$PublicationToJson(Publication instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'published': instance.published,
      'pub_type': instance.pubType,
      'pub_form': instance.pubForm,
      'pub_form_value': instance.pubFormValue,
    };
