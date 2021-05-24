import 'package:flutter/foundation.dart';
import 'package:lk_client/model/data_transfer/external_link.dart';
import 'package:lk_client/model/util/local_filesystem_object.dart';

abstract class AttachedInputState {}

class NoAttachedDataState extends AttachedInputState {}

class FileAttachedState extends AttachedInputState {
  final LocalFilesystemObject fileAttachment;
  FileAttachedState({@required this.fileAttachment});
}

class LinkAttachedState extends AttachedInputState {
  final ExternalLink attachedLink;
  LinkAttachedState({@required this.attachedLink});
}
