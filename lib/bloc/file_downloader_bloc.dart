import 'package:lk_client/bloc/abstract_bloc.dart';
import 'package:lk_client/event/file_management_event.dart';
import 'package:lk_client/service/api_consumer/file_transfer_service.dart';
import 'package:lk_client/service/app_config.dart';
import 'package:lk_client/service/file_local_manager.dart';
import 'package:lk_client/service/file_transfer_manager.dart';
import 'package:lk_client/state/file_management_state.dart';

class FileDownloaderBloc
    extends AbstractBloc<FileManagementState, FileManagementEvent> {
  Stream<FileManagementState> get downloaderStateStream =>
      this.stateContoller.stream.where((event) => event is FileManagementState);

  Stream<FileManagementEvent> get _downloaderEventStream => this
      .eventController
      .stream
      .where((event) => event is FileManagementEvent);

  FileDownloaderBloc(AppConfig config, FileLocalManager fileLocalManager, FileTransferService fileTransferService) {
    this.updateState(FileManagementInitState());

    this._downloaderEventStream.listen((FileManagementEvent event) async {
      if(event is FileCheckExistenceEvent) {
        this.updateState(CheckingExistenceState());
        String basePath = await fileLocalManager.getDefaultSaverDirectory();

        bool isExists = await fileLocalManager.isFileExists(filePath: fileLocalManager.getFilePath(basePath, event.fileName));

        if(isExists) {
          this.updateState(FileDownloadReadyState(
            fileName: event.fileName, 
            fileSize: await fileLocalManager.getFileSize(), 
            filePath: fileLocalManager.getFilePath(basePath, event.fileName)
          ));
        }
        else {
          this.updateState(FileNotExistsState());
        }
      }

      if(event is FileStartDownloadEvent) {
        
      }
    });
  }
}
