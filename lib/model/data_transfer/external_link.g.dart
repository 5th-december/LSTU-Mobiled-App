// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'external_link.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExternalLink _$ExternalLinkFromJson(Map<String, dynamic> json) {
  return ExternalLink(
    linkText: json['link_text'] as String,
    linkContent: json['link_content'] as String,
  );
}

Map<String, dynamic> _$ExternalLinkToJson(ExternalLink instance) =>
    <String, dynamic>{
      'link_text': instance.linkText,
      'link_content': instance.linkContent,
    };
