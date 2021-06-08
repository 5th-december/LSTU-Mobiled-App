import 'package:flutter/foundation.dart';
import 'package:lk_client/bloc/abstract_bloc.dart';
import 'package:lk_client/command/consume_command.dart';
import 'package:lk_client/event/file_management_event.dart';
import 'package:lk_client/model/util/local_filesystem_object.dart';
import 'package:lk_client/service/file_local_manager.dart';
import 'package:lk_client/service/file_transfer_manager.dart';
import 'package:lk_client/state/file_management_state.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class AbstractFileTransferBloc
    extends AbstractBloc<FileManagementState, FileManagementEvent> {
  Stream<FileManagementState> get binaryTransferStateStream =>
      this.stateContoller.stream.where((event) => event is FileManagementState);

  Stream<FileManagementEvent> get _initEventStream => this
      .eventController
      .stream
      .where((event) => event is FileManagementInitEvent);

  /*
   * При первичной инициализации блока запрашивается доступ к хранилищу
   */
  AbstractFileTransferBloc() {
    this._initEventStream.listen((event) async {
      final isPermittedFileOperations = await this.checkFilePermissions();
      if (isPermittedFileOperations) {
        this.updateState(FileManagementInitState());
      } else {
        this.updateState(FileManagementRightsErrorState());
      }
    });
  }

  void afterSuccessOperation(LocalFilesystemObject file) async {
    return;
  }

  Future<bool> checkFilePermissions() async {
    var permission = await Permission.storage.status;
    if (permission != PermissionStatus.granted) {
      await Permission.storage.request();
      permission = await Permission.storage.status;
    }
    return permission == PermissionStatus.granted;
  }
}

abstract class AbstractFileDownloaderBloc extends AbstractFileTransferBloc {
  FileLocalManager fileLocalManager;

  /*
   * Метод вызова транспорта файла, должен быть переопределен в унаследованном классе
   */
  Stream<FileOperationStatus> startDownloadingOperation(
      MultipartRequestCommand command, String filePath);

  /*
   * Стрим событий загрузки  
   */
  Stream<FileManagementEvent> get _downloadingEventStream =>
      this.eventController.stream.where(
          (event) => event is FileStartDownloadEvent<MultipartRequestCommand>);

  Future<String> getFirstApplicablePath(String fPath) async {
    if (fPath.isEmpty) {
      throw new Exception('Empty file path');
    }

    String path = fPath;
    int startingPoint = 1;
    while (await this.fileLocalManager.isFileExists(filePath: path)) {
      int lastDirPos = fPath.lastIndexOf('/');
      int pos = fPath.indexOf('.', lastDirPos == -1 ? 0 : lastDirPos);
      if (pos == -1) {
        pos = fPath.length - 1;
      }
      path = fPath.substring(0, pos) +
          '_' +
          (startingPoint++).toString() +
          fPath.substring(pos);
    }
    return path;
  }

  AbstractFileDownloaderBloc({@required this.fileLocalManager}) : super() {
    this._downloadingEventStream.listen((FileManagementEvent event) async {
      /* Доступно только, если получены разрешения на доступ к хранилищу */
      if (currentState is FileManagementRightsErrorState) return;

      final _event = event as FileStartDownloadEvent<MultipartRequestCommand>;

      String applicableFilePath =
          await this.getFirstApplicablePath(event.file.filePath);

      this.startDownloadingOperation(_event.command, applicableFilePath).listen(
          (iOEvent) async {
        if (iOEvent is FileOperationProgress) {
          // Передается состояние прогресса с величиной загруженной части
          this.updateState(FileOperationProgressState(rate: iOEvent.rate));
        } else if (iOEvent is FileOperationError) {
          // При ошибке загрузки
          this.updateState(FileOperationErrorState());
        } else if (iOEvent is FileOperationDone) {
          // Проверка существования файла
          bool isExists =
              await fileLocalManager.isFileExists(filePath: applicableFilePath);

          // В случае, если файл не существует по указанному пути, ошибка
          if (!isExists) {
            this.updateState(FileOperationErrorState());
            return;
          }

          /**
           * В унаследованном классе вызываются действия после совершения загрузки
           */
          this.afterSuccessOperation(_event.file);

          this.updateState(FileDownloadReadyState(
              filePath: applicableFilePath,
              fileName: fileLocalManager.getFileName(applicableFilePath),
              fileSize: await fileLocalManager.getSize(applicableFilePath)));
        }
      }, onError: (e) => this.updateState(FileOperationErrorState()));
    });
  }
}

abstract class AbstractFileUploaderBloc extends AbstractFileTransferBloc {
  /* Старт выгрузки документа, в унаследованном блоке должен быть соотв. сервис */
  Stream<FileOperationStatus> startUploadingOperation(
      MultipartRequestCommand command, String filePath);

  Stream<FileManagementEvent> get _uploadingEventStream => this
      .eventController
      .stream
      .where((event) => event is FileStartUploadEvent<MultipartRequestCommand>);

  AbstractFileUploaderBloc() : super() {
    this._uploadingEventStream.listen((event) {
      /* Доступно только, если получены разрешения на доступ к хранилищу */
      if (currentState is FileManagementRightsErrorState) return;

      final _event = event as FileStartUploadEvent<MultipartRequestCommand>;
      this
          .startUploadingOperation(_event.command, event.file.filePath)
          .listen((event) {
        if (event is FileOperationProgress) {
          // Передается состояние прогресса с величиной загруженной части
          this.updateState(FileOperationProgressState(rate: event.rate));
        } else if (event is FileOperationError) {
          // В случае, если ошибка
          this.updateState(FileOperationErrorState());
        } else if (event is FileOperationDone) {
          /**
           * В унаследованном классе вызываются действия после совершения выгрузки
           */
          this.afterSuccessOperation(_event.file);

          // При успешном окончании
          this.updateState(FileUploadReadyState());
        }
      });
    });
  }
}
