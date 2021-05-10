import 'package:flutter/foundation.dart';

abstract class FileManagementEvent {}

class FileFindLocallyEvent extends FileManagementEvent {
  final String filePath;
  FileFindLocallyEvent({@required this.filePath});
}

class FileFindInDirectoryEvent extends FileManagementEvent {
  final String basePath;
  final String fileName;
  FileFindInDirectoryEvent({@required this.basePath, @required this.fileName});
}

class FileStartDownloadEvent<T> extends FileManagementEvent {
  final T command;
  final String filePath;
  FileStartDownloadEvent({@required this.filePath, @required this.command});
}

class FileStartUploadEvent<T> extends FileManagementEvent {
  final T command;
  final String filePath;
  FileStartUploadEvent({@required this.filePath, @required this.command});
}
