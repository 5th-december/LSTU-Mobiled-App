import 'package:lk_client/bloc/abstract_bloc.dart';
import 'package:lk_client/command/consume_command.dart';
import 'package:lk_client/event/file_management_event.dart';
import 'package:lk_client/service/api_consumer/file_transfer_service.dart';
import 'package:lk_client/service/app_config.dart';
import 'package:lk_client/service/file_local_manager.dart';
import 'package:lk_client/service/file_transfer_manager.dart';
import 'package:lk_client/state/file_management_state.dart';

abstract class AbstractFileTransferBloc
    extends AbstractBloc<FileManagementState, FileManagementEvent> {
  Stream<FileManagementState> get binaryTransferStateStream =>
      this.stateContoller.stream.where((event) => event is FileManagementState);

  Stream<FileManagementEvent> get _binaryTransferEventStream => this
      .eventController
      .stream
      .where((event) => event is FileManagementEvent);

  FileTransferService transferService;

  /* Если унаследованный блок подразумевает только одну операцию - выгрузку или загрузку,
   * необязательно реализовывать оба метода, в отсутствующем можно вернуть null
   */

  /* Старт выгрузки документа, в унаследованном блоке должен быть соотв. сервис */
  Stream<FileOperationStatus> startUploadingOperation(
      MultipartRequestCommand command, String filePath);

  /* Загрузка документа, в унаследованном блоке - соотв. сервис */
  Stream<FileOperationStatus> startDownloadingOperation(
      MultipartRequestCommand command, String filePath);

  AbstractFileTransferBloc(AppConfig config, FileLocalManager fileLocalManager,
      this.transferService) {
    this._binaryTransferEventStream.listen((FileManagementEvent event) async {
      /* В случае, если принят такой event, блок инициализируется пустым занчением */
      if (event is FileManagementInitEvent) {
        this.updateState(FileManagementInitState());
      }

      /* Для eventов поиска в директориях */
      if (event is FileFindLocallyEvent ||
          event is FileFindInDirectoryEvent ||
          event is FileFindInDefaultDocumentLocationEvent) {
        this.updateState(FileLocationProgressState());

        bool isExists =
            await fileLocalManager.isFileExists(filePath: event.file.filePath);

        if (isExists) {
          final Map<String, bool> permissions =
              await fileLocalManager.getPremissions(event.file.filePath);
          this.updateState(FileLocatedState(
              filePath: event.file.filePath,
              w: permissions['w'],
              r: permissions['r']));
        } else {
          final String basePath =
              fileLocalManager.getFileBase(event.file.filePath);
          final Map<String, bool> permissions =
              await fileLocalManager.getPremissions(basePath);
          this.updateState(FileUnlocatedState(
              filePath: event.file.filePath, w: permissions['w']));
        }
      }

      /*
       * Загрузка доступна только в случае, если файл не был найден и директория 
       * доступна для записи
       * либо если файл найден и может быть заменен
       */
      if (event is FileStartDownloadEvent<MultipartRequestCommand> &&
          ((currentState is FileUnlocatedState &&
                  (currentState as FileUnlocatedState).w) ||
              (currentState is FileLocatedState &&
                  (currentState as FileLocatedState).w))) {
        if (currentState is FileLocatedState) {
          fileLocalManager.deleteFile(event.file.filePath);
        }

        this
            .startDownloadingOperation(event.command, event.file.filePath)
            .listen((iOEvent) async {
          if (iOEvent is FileOperationProgress) {
            this.updateState(FileOperationProgressState(rate: iOEvent.rate));
          } else if (iOEvent is FileOperationError) {
            this.updateState(FileOperationErrorState());
          } else if (iOEvent is FileOperationDone) {
            bool isExists = await fileLocalManager.isFileExists(
                filePath: event.file.filePath);

            if (!isExists) {
              this.updateState(FileOperationErrorState());
              return;
            }

            this.updateState(FileDownloadReadyState(
                filePath: event.file.filePath,
                fileName: fileLocalManager.getFileName(event.file.filePath),
                fileSize: await fileLocalManager.getSize(event.file.filePath)));
          }
        });
      }

      /*
       * Выгрузка доступна только если файл найден по указанному пути
       */
      if (event is FileStartUploadEvent<MultipartRequestCommand> &&
          ((currentState is FileLocatedState &&
                  (currentState as FileLocatedState).r) ||
              currentState is FileDownloadReadyState)) {
        this
            .startUploadingOperation(event.command, event.file.filePath)
            .listen((event) {
          if (event is FileOperationProgress) {
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
