import 'package:flutter/foundation.dart';
import 'package:lk_client/model/messenger/private_message.dart';

abstract class MultipartRequestCommand {}

class LoadTeachingMaterialAttachment extends MultipartRequestCommand {
  final String teachingMaterial;
  LoadTeachingMaterialAttachment(this.teachingMaterial);
}

class UploadPrivateMessageAttachment extends MultipartRequestCommand {
  final PrivateMessage message;
  UploadPrivateMessageAttachment({@required this.message});
}