import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'external_link.g.dart';

@JsonSerializable()
class ExternalLink
{
  @JsonKey(name: 'link_text')
  final String linkText;

  @JsonKey(name: 'link_content')
  final String linkContent;

  ExternalLink({this.linkText, this.linkContent});

  factory ExternalLink.fromJson(Map<String, dynamic> json) => _$ExternalLinkFromJson(json);
  Map<String, dynamic> toJson() => _$ExternalLinkToJson(this);
}