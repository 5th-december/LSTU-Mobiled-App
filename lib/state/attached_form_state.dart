import 'package:lk_client/model/data_transfer/external_link.dart';
import 'package:lk_client/model/util/local_filesystem_object.dart';

abstract class AttachedFormInputState<T> {
  final LocalFilesystemObject fileAttachment;
  final ExternalLink attachedLink;
  final T formTypeInputObject;
  AttachedFormInputState(
      {this.attachedLink, this.fileAttachment, this.formTypeInputObject});
}

class WaitUserInputState<T> extends AttachedFormInputState<T> {
  WaitUserInputState(
      {LocalFilesystemObject fileAttachment,
      ExternalLink attachedLink,
      T formTypeInputObject})
      : super(
            attachedLink: attachedLink,
            fileAttachment: fileAttachment,
            formTypeInputObject: formTypeInputObject);
}

class ObjectReadyFormInputState<T> extends AttachedFormInputState<T> {
  ObjectReadyFormInputState(
      {LocalFilesystemObject fileAttachment,
      ExternalLink attachedLink,
      T formTypeInputObject})
      : super(
            attachedLink: attachedLink,
            fileAttachment: fileAttachment,
            formTypeInputObject: formTypeInputObject);
}
