import 'package:flutter/foundation.dart';

abstract class FileManagementState {}

class FileManagementInitState extends FileManagementState {}

class FileFindLocallyProgressState extends FileManagementState {}

class FileNotFoundLocallyState extends FileManagementState {}

class FileFoundLocallyState extends FileManagementState {}

class FileOperationProgressState extends FileManagementState {
  final double rate;
  FileOperationProgressState({this.rate});
}

class FileOperationErrorState extends FileManagementState {
  final Exception error;
  FileOperationErrorState({this.error});
}

class FileDownloadReadyState extends FileManagementState {
  final String filePath;
  final String fileName;
  final int fileSize;
  FileDownloadReadyState(
      {@required this.filePath,
      @required this.fileName,
      @required this.fileSize});
}

class FileUploadReadyState extends FileManagementState {}