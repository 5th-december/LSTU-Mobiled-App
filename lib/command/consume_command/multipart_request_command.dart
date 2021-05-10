abstract class MultipartRequestCommand {}

class LoadTeachingMaterialAttachment extends MultipartRequestCommand {
  final String teachingMaterial;
  LoadTeachingMaterialAttachment(this.teachingMaterial);
}
