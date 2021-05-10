import 'package:flutter/foundation.dart';

abstract class FileManagementEvent {}

class FileCheckExistenceEvent extends FileManagementEvent {
  final String filePath;
  final String fileName;
  FileCheckExistenceEvent({@required this.fileName, @required this.filePath});
}

class FileStartDownloadEvent extends FileManagementEvent {
  final String filePath;
  final String fileName;
  FileStartDownloadEvent({@required this.fileName, @required this.filePath});
}
