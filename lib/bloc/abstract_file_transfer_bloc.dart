import 'package:lk_client/bloc/abstract_bloc.dart';
import 'package:lk_client/command/consume_command/multipart_request_command.dart';
import 'package:lk_client/event/file_management_event.dart';
import 'package:lk_client/service/api_consumer/file_transfer_service.dart';
import 'package:lk_client/service/app_config.dart';
import 'package:lk_client/service/file_local_manager.dart';
import 'package:lk_client/service/file_transfer_manager.dart';
import 'package:lk_client/state/file_management_state.dart';

abstract class AbstractFileTransferBloc
    extends AbstractBloc<FileManagementState, FileManagementEvent> {
  Stream<FileManagementState> get downloaderStateStream =>
      this.stateContoller.stream.where((event) => event is FileManagementState);

  Stream<FileManagementEvent> get _downloaderEventStream => this
      .eventController
      .stream
      .where((event) => event is FileManagementEvent);

  FileTransferService transferService;

  Stream<FileOperationStatus> startUploadingOperation(MultipartRequestCommand command, String filePath);

  Stream<FileOperationStatus> startDownloadingOperation(MultipartRequestCommand command, String filePath);

  AbstractFileTransferBloc(AppConfig config, FileLocalManager fileLocalManager, this.transferService) {
    this.updateState(FileManagementInitState());

    this._downloaderEventStream.listen((FileManagementEvent event) async {
      if (event is FileFindLocallyEvent || event is FileFindInDirectoryEvent) {
        this.updateState(FileFindLocallyProgressState());

        String filePath = '';
        if(event is FileFindLocallyEvent) {
          filePath = event.filePath;
        } else if(event is FileFindInDirectoryEvent){
          filePath = fileLocalManager.getFilePath(event.basePath, event.fileName);
        }

        bool isExists = await fileLocalManager.isFileExists(filePath: filePath);

        if (isExists) {
          this.updateState(FileFoundLocallyState());
        } else {
          this.updateState(FileNotFoundLocallyState());
        }
        
      }

      if (event is FileStartDownloadEvent<MultipartRequestCommand> && currentState is FileNotFoundLocallyState) {
        this.startDownloadingOperation(event.command, event.filePath).listen((iOEvent) async {
          if(iOEvent is FileOperationProgress) {
            this.updateState(FileOperationProgressState(rate: iOEvent.rate));
          } else if(iOEvent is FileOperationError) {
            this.updateState(FileOperationErrorState());
          } else if(iOEvent is FileOperationDone) {
            bool isExists = await fileLocalManager.isFileExists(filePath: event.filePath);

            if(!isExists) {
              this.updateState(FileOperationErrorState());
              return;
            }

            this.updateState(
              FileDownloadReadyState(
                filePath: event.filePath,
                fileName: fileLocalManager.getFileName(event.filePath),
                fileSize: await fileLocalManager.getFileSize(filePath: event.filePath)
              )
            );
          } 
        });
      }

      if (event is FileStartUploadEvent<MultipartRequestCommand> && 
        (currentState is FileFoundLocallyState || currentState is FileDownloadReadyState)) {
          this.startUploadingOperation(event.command, event.filePath).listen((event) {
            if(event is FileOperationProgress) {
              this.updateState(FileOperationProgressState(rate: event.rate));
            } else if (event is FileOperationError) {
              this.updateState(FileOperationErrorState());
            } else if (event is FileOperationDone) {
              this.updateState(FileUploadReadyState());
            }
          });
      }
    });
  }
}
