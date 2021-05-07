import 'package:json_annotation/json_annotation.dart';
import 'package:lk_client/model/data_transfer/attachment.dart';
import 'package:lk_client/model/data_transfer/external_link.dart';

part 'teaching_material.g.dart';

@JsonSerializable()
class TeachingMaterial {
  final String id;

  @JsonKey(name: 'material_name')
  final String materialName;

  @JsonKey(name: 'material_type')
  final String materialType;

  final Attachment attachment;

  @JsonKey(name: 'external_link')
  final ExternalLink externalLink;

  TeachingMaterial(
      {this.id,
      this.attachment,
      this.externalLink,
      this.materialName,
      this.materialType});

  static TeachingMaterial fromJson(Map<String, dynamic> json) =>
      _$TeachingMaterialFromJson(json);
  Map<String, dynamic> toJson() => _$TeachingMaterialToJson(this);
}
