import 'package:lk_client/service/file_transfer_manager.dart';

class FileTransferService {
  final FileTransferManager fileTransferManager;

  FileTransferService(this.fileTransferManager);

  Stream<FileOperationStatus> downloadTeachingMaterialsAttachment(
      String teachingMaterialId, String filePath) async* {
    yield* this.fileTransferManager.progressedDownload(
        '/api/v1/materials/doc', {'material': teachingMaterialId}, filePath);
  }
}
