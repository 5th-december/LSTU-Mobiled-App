import 'package:flutter/foundation.dart';

abstract class AttachedInputEvent {}

class InitAttachedInputEvent extends AttachedInputEvent {}

class AddFileAttachmentEvent extends AttachedInputEvent {
  final String attachmentPath;
  AddFileAttachmentEvent({@required this.attachmentPath});
}

class RemoveFileAttachmentEvent extends AttachedInputEvent {}

class AddExternalLinkEvent extends AttachedInputEvent {
  final String externalLinkText;
  final String extenalLinkContent;
  AddExternalLinkEvent(
      {@required this.extenalLinkContent, @required this.externalLinkText});
}

class RemoveExternalLinkEvent extends AttachedInputEvent {}
