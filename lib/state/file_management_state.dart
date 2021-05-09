import 'package:flutter/foundation.dart';

abstract class FileManagementState {}

class FileManagementInitState extends FileManagementState {}

class CheckingExistenceState extends FileManagementState {}

class FileNotExistsState extends FileManagementState {}

class FileDownloadProgressState extends FileManagementState {
  final double downloadRate;
  FileDownloadProgressState({this.downloadRate});
}

class FileDownloadErrorState extends FileManagementState {
  final Exception error;
  FileDownloadErrorState(this.error);
}

class FileDownloadReadyState extends FileManagementState {
  final String filePath;
  final double fileSize;
  final String fileName;
  FileDownloadReadyState(
      {@required this.fileName,
      @required this.fileSize,
      @required this.filePath});
}
