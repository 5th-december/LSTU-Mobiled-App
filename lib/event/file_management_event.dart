import 'package:flutter/foundation.dart';

abstract class FileManagementEvent {}

class FileCheckExistenceEvent extends FileManagementEvent {
  final String basePath;
  final String fileName;
  final String filePath;
  FileCheckExistenceEvent({this.fileName, this.basePath, this.filePath});
}

class FileStartDownloadEvent extends FileManagementEvent {
  final String basePath;
  final String fileName;
  FileStartDownloadEvent({@required this.fileName, @required this.basePath});
}

class FileStartUploadEvent extends FileManagementEvent {
  final String filePath;
  FileStartUploadEvent({@required this.filePath});
}
