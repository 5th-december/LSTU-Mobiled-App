import 'package:flutter/foundation.dart';

abstract class FileManagementState {
  final String filePath;
  FileManagementState({this.filePath});
}

class FileManagementInitState extends FileManagementState {}

class FileFindLocallyProgressState extends FileManagementState {
  FileFindLocallyProgressState({String filePath}) : super(filePath: filePath);
}

class FileNotFoundLocallyState extends FileManagementState {
  FileNotFoundLocallyState({String filePath}) : super(filePath: filePath);
}

class FileFoundLocallyState extends FileManagementState {
  FileFoundLocallyState({String filePath}) : super(filePath: filePath);
}

class FileOperationProgressState extends FileManagementState {
  final double rate;
  FileOperationProgressState({this.rate});
}

class FileOperationErrorState extends FileManagementState {
  final Exception error;
  FileOperationErrorState({this.error});
}

class FileDownloadReadyState extends FileManagementState {
  final String fileName;
  final int fileSize;
  FileDownloadReadyState(
      {@required String filePath,
      @required this.fileName,
      @required this.fileSize})
      : super(filePath: filePath);
}

class FileUploadReadyState extends FileManagementState {
  FileUploadReadyState({String filePath}) : super(filePath: filePath);
}
