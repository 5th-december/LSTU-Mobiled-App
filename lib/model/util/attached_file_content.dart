import 'package:flutter/foundation.dart';
import 'package:lk_client/model/util/local_filesystem_object.dart';

class AttachedFileContent<T> {
  final T content;
  final LocalFilesystemObject file;
  AttachedFileContent({@required this.content,this.file});
}