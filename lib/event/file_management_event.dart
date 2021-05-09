import 'package:flutter/foundation.dart';

abstract class FileManagementEvent {}

class FileCheckExistenceEvent extends FileManagementEvent {
  final String filePath;
  final String fileName;
  FileCheckExistenceEvent({@required this.fileName, @required this.filePath});
}

class FileDownloadEvent extends FileManagementEvent {
  final String filePath;
  final String fileName;
  FileDownloadEvent({@required this.fileName, @required this.filePath});
}
