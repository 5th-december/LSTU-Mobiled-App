import 'package:lk_client/service/file_transfer_manager.dart';
import 'package:path_provider/path_provider.dart';

class FileTransferService
{
  final FileTransferManager fileTransferManager;

  FileTransferService(this.fileTransferManager);

  Stream<FileOperationStatus> downloadTeachingMaterialsAttachment(String teachingMaterialId, String filename) async*
  {
    final String downloadDirectory = (await getApplicationDocumentsDirectory()).path;
    yield* this.fileTransferManager.progressedDownload(
      '/api/v1/materials/doc', filename, {'material': teachingMaterialId}, basePath: downloadDirectory);
  }

  
}