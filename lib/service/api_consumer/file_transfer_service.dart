import 'package:lk_client/service/file_transfer_manager.dart';

class FileTransferService {
  final FileTransferManager fileTransferManager;

  FileTransferService(this.fileTransferManager);

  Stream<FileOperationStatus> downloadTeachingMaterialsAttachment(
      String teachingMaterialId, String filePath) async* {
    yield* this.fileTransferManager.progressedDownload(
        '/api/v1/materials/doc', <String, String>{'material': teachingMaterialId}, filePath);
  }

  Stream<FileOperationStatus> uploadPrivateMessageAttachment(
    String privateMessageId, String filePath) async* {
    yield* this.fileTransferManager.progressedUpload
      ('/api/v1/messenger/doc', <String, String>{'pmsg': privateMessageId}, filePath);
  }
}
