import 'package:flutter/foundation.dart';
import 'package:lk_client/bloc/abstract_attached_form_bloc.dart';
import 'package:lk_client/model/util/local_filesystem_object.dart';

abstract class FileManagementEvent {
  final LocalFilesystemObject file;
  FileManagementEvent({this.file});
}

class FileManagementInitEvent extends FileManagementEvent {}

class FileFindLocallyEvent extends FileManagementEvent {
  FileFindLocallyEvent({@required LocalFilesystemObject file}): super(file: file);
}

class FileFindInDirectoryEvent extends FileManagementEvent {
  LocalFilesystemObject file;
  FileFindInDirectoryEvent({@required String basePath, @required String fileName}) {
    this.file = LocalFilesystemObject.fromNameAndBase(basePath, fileName);
  }
}

class FileFindInDefaultDocumentLocationEvent extends FileManagementEvent {
  LocalFilesystemObject file; // TODO: Initial method
  FileFindInDefaultDocumentLocationEvent();
}

class FileStartDownloadEvent<T> extends FileManagementEvent {
  final T command;
  FileStartDownloadEvent(
    {@required LocalFilesystemObject file, @required this.command}): super(file: file);
}

class FileStartUploadEvent<T> extends FileManagementEvent {
  final T command;
  FileStartUploadEvent(
    {@required LocalFilesystemObject file, @required this.command}): super(file: file);
}
