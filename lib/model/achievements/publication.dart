import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'publication.g.dart';

@JsonSerializable()
class Publication {
  final String id;

  final String title;

  final String description;

  final String published;

  @JsonKey(name: 'pub_type')
  final String pubType;

  @JsonKey(name: 'pub_form')
  final String pubForm;

  @JsonKey(name: 'pub_form_value')
  final String pubFormValue;

  Publication(
      {@required this.id,
      this.title,
      this.description,
      this.published,
      this.pubType,
      this.pubForm,
      this.pubFormValue});

  static Publication fromJson(Map<String, dynamic> json) =>
      _$PublicationFromJson(json);
  Map<String, dynamic> toJson() => _$PublicationToJson(this);
}
