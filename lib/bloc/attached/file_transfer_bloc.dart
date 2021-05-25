import 'package:flutter/foundation.dart';
import 'package:lk_client/bloc/attached/abstract_file_transfer_bloc.dart';
import 'package:lk_client/command/consume_command.dart';
import 'package:lk_client/model/util/local_filesystem_object.dart';
import 'package:lk_client/service/api_consumer/file_transfer_service.dart';
import 'package:lk_client/service/file_local_manager.dart';
import 'package:lk_client/service/file_transfer_manager.dart';
import 'package:lk_client/service/notification/notification_producer.dart';
import 'package:lk_client/service/notification/notifier.dart';

class TeachingMaterialDocumentTransferBloc extends AbstractFileDownloaderBloc {
  final FileTransferService fileTransferService;
  final Notifier appNotifier;

  TeachingMaterialDocumentTransferBloc(
      {@required FileLocalManager fileLocalManager,
      @required this.appNotifier,
      @required this.fileTransferService})
      : super(fileLocalManager);

  @override
  Stream<FileOperationStatus> startDownloadingOperation(
      MultipartRequestCommand command, String filePath) {
    LoadTeachingMaterialAttachment _command =
        command as LoadTeachingMaterialAttachment;
    return this.fileTransferService.downloadTeachingMaterialsAttachment(
        _command.teachingMaterial, filePath);
  }

  @override
  void afterSuccessOperation(LocalFilesystemObject file) async {
    FileDownloadNotificationProducer notificationProducer =
        FileDownloadNotificationProducer(
            notifier: this.appNotifier, downloadedSuccess: true, file: file);
    notificationProducer.notify();
  }
}

class PrivateMessageSendDocumentTransferBloc extends AbstractFileUploaderBloc {
  final FileTransferService fileTransferService;

  PrivateMessageSendDocumentTransferBloc({@required this.fileTransferService});

  @override
  Stream<FileOperationStatus> startUploadingOperation(
      MultipartRequestCommand command, String filePath) {
    UploadPrivateMessageAttachment _command =
        command as UploadPrivateMessageAttachment;
    return this
        .fileTransferService
        .uploadPrivateMessageAttachment(_command.message.id, filePath);
  }
}

class DiscussionMessageSendDocumentTransferBloc
    extends AbstractFileUploaderBloc {
  final FileTransferService fileTransferService;

  DiscussionMessageSendDocumentTransferBloc(
      {@required this.fileTransferService});

  @override
  Stream<FileOperationStatus> startUploadingOperation(
      MultipartRequestCommand command, String filePath) {
    UploadPrivateMessageAttachment _command =
        command as UploadPrivateMessageAttachment;
    return this
        .fileTransferService
        .uploadDiscussionMessageAttachment(_command.message.id, filePath);
  }
}
