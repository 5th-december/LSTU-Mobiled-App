import 'package:flutter/foundation.dart';
import 'package:lk_client/model/data_transfer/external_link.dart';
import 'package:lk_client/model/util/local_filesystem_object.dart';

abstract class AttachedFormInputEvent {}

class InitAttachedFormInputEvent extends AttachedFormInputEvent {}

class AddFileAttachmentEvent extends AttachedFormInputEvent {
  final String attachmentPath;
  AddFileAttachmentEvent({@required this.attachmentPath});
}

class RemoveFileAttachmentEvent extends AttachedFormInputEvent {}

class AddExternalLinkEvent extends AttachedFormInputEvent {
  final String externalLinkText;
  final String extenalLinkContent;
  AddExternalLinkEvent(
      {@required this.extenalLinkContent, @required this.externalLinkText});
}

class RemoveExternalLinkEvent extends AttachedFormInputEvent {}

class PrepareFormObjectEvent extends AttachedFormInputEvent {}

class AttachedFormExternalInitEvent<T> extends AttachedFormInputEvent {
  final T initialFormDataObject;
  final LocalFilesystemObject fileAttachment;
  final ExternalLink attachedLink;
  AttachedFormExternalInitEvent(
      {@required this.initialFormDataObject,
      this.fileAttachment,
      this.attachedLink});
}
