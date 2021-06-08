import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/bloc/abstract_bloc.dart';
import 'package:lk_client/bloc/attached/abstract_file_transfer_bloc.dart';
import 'package:lk_client/bloc/attached/file_transfer_bloc.dart';
import 'package:lk_client/command/consume_command.dart';
import 'package:lk_client/event/file_management_event.dart';
import 'package:lk_client/model/data_transfer/attachment.dart';
import 'package:lk_client/model/data_transfer/external_link.dart';
import 'package:lk_client/model/util/local_filesystem_object.dart';
import 'package:lk_client/service/api_consumer/file_transfer_service.dart';
import 'package:lk_client/service/file_local_manager.dart';
import 'package:lk_client/service/notification/notifier.dart';
import 'package:lk_client/state/file_management_state.dart';
import 'package:path_provider/path_provider.dart';

class FileDownloaderBlocProvider {
  Map<String, AbstractFileDownloaderBloc> _loaders =
      <String, AbstractFileDownloaderBloc>{};

  AbstractFileDownloaderBloc getLoader(String fileMaterialIdentifier) {
    if (this._loaders.containsKey(fileMaterialIdentifier)) {
      return _loaders[fileMaterialIdentifier];
    } else {
      return null;
    }
  }

  bool putLoader(String fileMaterialIdentifier,
      AbstractFileDownloaderBloc downloaderBloc) {
    final contains = this._loaders.containsKey(fileMaterialIdentifier);

    if (!contains) {
      this._loaders[fileMaterialIdentifier] = downloaderBloc;
      return !contains;
    }

    return contains;
  }
}

class TeachingMaterialsDownloaderProxyBloc
    extends FileDownloaderProxyBloc<TeachingMaterialDocumentDownloaderBloc> {
  FileLocalManager fileLocalManager;

  Notifier appNotifier;

  FileTransferService fileTransferService;

  TeachingMaterialsDownloaderProxyBloc(
      {@required this.fileLocalManager,
      @required this.appNotifier,
      @required this.fileTransferService,
      @required FileDownloaderBlocProvider fileDownloaderBlocProvider})
      : super(fileDownloaderBlocProvider: fileDownloaderBlocProvider);

  @override
  TeachingMaterialDocumentDownloaderBloc buildDownloaderInstance() {
    return TeachingMaterialDocumentDownloaderBloc(
        fileLocalManager: fileLocalManager,
        appNotifier: appNotifier,
        fileTransferService: fileTransferService);
  }
}

class StudentTaskAnswerDownloaderProxyBloc
    extends FileDownloaderProxyBloc<StudentTaskAnswerDocumentDownloaderBloc> {
  FileLocalManager fileLocalManager;

  Notifier appNotifier;

  FileTransferService fileTransferService;

  StudentTaskAnswerDownloaderProxyBloc(
      {@required this.appNotifier,
      @required this.fileLocalManager,
      @required this.fileTransferService,
      @required FileDownloaderBlocProvider fileDownloaderBlocProvider})
      : super(fileDownloaderBlocProvider: fileDownloaderBlocProvider);

  @override
  StudentTaskAnswerDocumentDownloaderBloc buildDownloaderInstance() {
    return StudentTaskAnswerDocumentDownloaderBloc(
        fileLocalManager: this.fileLocalManager,
        appNotifier: this.appNotifier,
        fileTransferService: this.fileTransferService);
  }
}

class PrivateMessageDownloaderProxyBloc
    extends FileDownloaderProxyBloc<PrivateMessageDocumentDownloaderBloc> {
  FileLocalManager fileLocalManager;

  Notifier appNotifier;

  FileTransferService fileTransferService;

  PrivateMessageDownloaderProxyBloc(
      {@required this.appNotifier,
      @required this.fileLocalManager,
      @required this.fileTransferService,
      @required FileDownloaderBlocProvider fileDownloaderBlocProvider})
      : super(fileDownloaderBlocProvider: fileDownloaderBlocProvider);

  @override
  PrivateMessageDocumentDownloaderBloc buildDownloaderInstance() {
    return PrivateMessageDocumentDownloaderBloc(
        appNotifier: this.appNotifier,
        fileLocalManager: this.fileLocalManager,
        fileTransferService: this.fileTransferService);
  }
}

class DiscussionMessageDownloaderProxyBloc
    extends FileDownloaderProxyBloc<DiscussionMessageDocumentDownloaderBloc> {
  FileLocalManager fileLocalManager;

  Notifier appNotifier;

  FileTransferService fileTransferService;

  DiscussionMessageDownloaderProxyBloc(
      {@required this.appNotifier,
      @required this.fileLocalManager,
      @required this.fileTransferService,
      @required FileDownloaderBlocProvider fileDownloaderBlocProvider})
      : super(fileDownloaderBlocProvider: fileDownloaderBlocProvider);

  @override
  DiscussionMessageDocumentDownloaderBloc buildDownloaderInstance() {
    return DiscussionMessageDocumentDownloaderBloc(
        appNotifier: this.appNotifier,
        fileTransferService: this.fileTransferService,
        fileLocalManager: this.fileLocalManager);
  }
}

/* 
 * Предоставляет классу виджета выполняемый или сохраненный файл, а
 * если таких не найдено, то инициализирует в подклассе новый объект блока загрузки 
 * и при первой операции загрузки кладет ее в провайдер блоков загрузки
 */
abstract class FileDownloaderProxyBloc<T extends AbstractFileDownloaderBloc>
    extends AbstractBloc<FileManagementState, FileManagementEvent> {
  /*
   * Объект downloadera заданного типаf
   */
  AbstractFileDownloaderBloc _fileDownloaderBloc;

  /*
   * Стрим состояний файловых операций
   */
  Stream<FileManagementState> get downloadFileManagementStateStream =>
      this.stateContoller.stream;

  /*
   * Стрим событий файловых операций
   */
  Stream<FileManagementEvent> get _downloadFileInitEventStream => this
      .eventController
      .stream
      .where((event) => event is FileDownloadInitEvent);

  Stream<FileManagementEvent> get _downloadManagementEventStream => this
      .eventController
      .stream
      .where((event) => event is FileManagementEvent);

  T buildDownloaderInstance();

  FileDownloaderProxyBloc(
      {@required FileDownloaderBlocProvider fileDownloaderBlocProvider}) {
    this._downloadFileInitEventStream.listen((event) {
      final _event = event as FileDownloadInitEvent;

      final progressFileDownloader =
          fileDownloaderBlocProvider.getLoader(_event.fileMaterialIdentifier);

      if (progressFileDownloader != null && progressFileDownloader is T) {
        this._fileDownloaderBloc = progressFileDownloader;
        this._fileDownloaderBloc.binaryTransferStateStream.listen(
            (event) => this.stateContoller.sink.add(event),
            onError: (e) => this.stateContoller.sink.add(e));
      } else {
        this._fileDownloaderBloc = this.buildDownloaderInstance();
        this._fileDownloaderBloc.binaryTransferStateStream.listen(
            (event) => this.stateContoller.sink.add(event),
            onError: (e) => this.stateContoller.sink.add(e));
        this
            ._fileDownloaderBloc
            .eventController
            .sink
            .add(FileManagementInitEvent());
      }

      this._downloadManagementEventStream.listen((event) {
        if (fileDownloaderBlocProvider
                .getLoader(_event.fileMaterialIdentifier) ==
            null) {
          fileDownloaderBlocProvider.putLoader(
              _event.fileMaterialIdentifier, this._fileDownloaderBloc);
        }
        this._fileDownloaderBloc.eventController.sink.add(event);
      });
    });
  }
}

class DownloadFileMaterial {
  final Attachment attachment;
  final MultipartRequestCommand command;
  final String attachmentId;
  final String originalFileName;
  DownloadFileMaterial(
      {@required this.attachment,
      @required this.command,
      @required this.attachmentId,
      @required this.originalFileName});
}

class DownloadExternalLinkMaterial {
  final ExternalLink externalLink;
  DownloadExternalLinkMaterial({@required this.externalLink});
}

class FileDownloadWidget extends StatefulWidget {
  final FileDownloaderProxyBloc proxyBloc;
  final DownloadFileMaterial fileMaterial;

  FileDownloadWidget(
      {Key key, @required this.proxyBloc, @required this.fileMaterial})
      : super(key: key);

  @override
  _FileDownloadWidgetState createState() => _FileDownloadWidgetState();
}

class _FileDownloadWidgetState extends State<FileDownloadWidget> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.proxyBloc.eventController.add(FileDownloadInitEvent(
        fileMaterialIdentifier: widget.fileMaterial.attachmentId));
  }

  @override
  Widget build(BuildContext context) {
    String fileExtension =
        widget.fileMaterial.attachment.attachmentName.split('.')?.last ?? '';
    double fileSize =
        double.parse(widget.fileMaterial.attachment.attachmentSize);
    String sizeTitle = fileSize > 1024
        ? (fileSize / 1024).toStringAsFixed(2) + ' Мб.'
        : fileSize.toStringAsFixed(2) + ' Кб.';

    return StreamBuilder(
        stream: widget.proxyBloc.downloadFileManagementStateStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            FileManagementState state = (snapshot.data) as FileManagementState;
            if (state is FileManagementInitState) {
              return this.getDownloadAvailableWidget(state, widget.fileMaterial,
                  fileExtension, fileSize, sizeTitle);
            }
            if (state is FileManagementRightsErrorState) {
              return this.fileManagementRightsError();
            }
            if (state is FileOperationProgressState) {
              return this.getDownloadProgressWidget(state, widget.fileMaterial);
            }
            if (state is FileOperationErrorState) {
              return this.fileDownloadErrorWidget(state, widget.fileMaterial,
                  fileExtension, fileSize, sizeTitle);
            }
            if (state is FileDownloadReadyState) {
              return this.fileDownloadingReadyWidget(state, widget.fileMaterial,
                  fileExtension, fileSize, sizeTitle);
            }
          }

          return SizedBox.shrink();
        });
  }

  Widget getDownloadProgressWidget(
      FileOperationProgressState state, DownloadFileMaterial material) {
    int percent = ((state.rate /
                (double.parse(material.attachment.attachmentSize) * 1024)) *
            100.0)
        .round();

    return Container(
        constraints: BoxConstraints(maxWidth: 220.0, minWidth: 220.0),
        padding: EdgeInsets.all(7.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
                color: Color.fromRGBO(139, 62, 252, 1.0), width: 3.0)),
        child: Row(
          children: [
            ElevatedButton(
                onPressed: () => {},
                child: Text('$percent %'),
                style: ElevatedButton.styleFrom(
                    primary: Color.fromRGBO(139, 62, 252, 1.0),
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(8.0))),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  material.attachment.attachmentName,
                  maxLines: 2,
                  style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 3.0),
                Text(
                  'Загружается',
                  maxLines: 1,
                  style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ))
          ],
        ));
  }

  Widget getDownloadAvailableWidget(
      FileManagementInitState state,
      DownloadFileMaterial material,
      String fileExtension,
      double fileSize,
      String sizeTitle) {
    return Container(
        constraints: BoxConstraints(maxWidth: 220.0, minWidth: 220.0),
        padding: EdgeInsets.all(7.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
                color: Color.fromRGBO(139, 62, 252, 1.0), width: 3.0)),
        child: Row(
          children: [
            ElevatedButton(
                onPressed: () => downloadFileToDirectory(material),
                child: Icon(Icons.download_rounded, size: 32.0),
                style: ElevatedButton.styleFrom(
                    primary: Color.fromRGBO(139, 62, 252, 1.0),
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(8.0))),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  material.attachment.attachmentName,
                  maxLines: 2,
                  style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 3.0,
                ),
                Text(
                  '$fileExtension $sizeTitle',
                  maxLines: 1,
                  style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ))
          ],
        ));
  }

  Widget fileDownloadingReadyWidget(
      FileDownloadReadyState state,
      DownloadFileMaterial material,
      String fileExtension,
      double fileSize,
      String sizeTitle) {
    return Container(
        constraints: BoxConstraints(maxWidth: 220.0, minWidth: 220.0),
        padding: EdgeInsets.all(7.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
                color: Color.fromRGBO(139, 62, 252, 1.0), width: 3.0)),
        child: Row(
          children: [
            ElevatedButton(
                onPressed: () => {},
                child: Icon(Icons.download_done_rounded, size: 32.0),
                style: ElevatedButton.styleFrom(
                    primary: Color.fromRGBO(139, 62, 252, 1.0),
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(8.0))),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  material.attachment.attachmentName,
                  maxLines: 2,
                  style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 3.0,
                ),
                Text(
                  '$fileExtension $sizeTitle',
                  maxLines: 1,
                  style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ))
          ],
        ));
  }

  Widget fileDownloadErrorWidget(
      FileOperationErrorState state,
      DownloadFileMaterial material,
      String fileExtension,
      double fileSize,
      String sizeTitle) {
    return Container(
        constraints: BoxConstraints(maxWidth: 220.0, minWidth: 220.0),
        padding: EdgeInsets.all(7.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
                color: Color.fromRGBO(139, 62, 252, 1.0), width: 3.0)),
        child: Row(
          children: [
            ElevatedButton(
                onPressed: () => downloadFileToDirectory(material),
                child: Icon(Icons.error_outline_rounded, size: 32.0),
                style: ElevatedButton.styleFrom(
                    primary: Color.fromRGBO(139, 62, 252, 1.0),
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(8.0))),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  material.attachment.attachmentName,
                  maxLines: 2,
                  style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 3.0),
                Text(
                  'Ошибка загрузки',
                  maxLines: 1,
                  style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ))
          ],
        ));
  }

  Widget fileManagementRightsError() {
    return Container(
        constraints: BoxConstraints(maxWidth: 220.0, minWidth: 220.0),
        padding: EdgeInsets.all(7.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
                color: Color.fromRGBO(139, 62, 252, 1.0), width: 3.0)),
        child: Row(
          children: [
            ElevatedButton(
                onPressed: () async => {},
                child: Icon(Icons.warning_amber_rounded, size: 32.0),
                style: ElevatedButton.styleFrom(
                    primary: Color.fromRGBO(139, 62, 252, 1.0),
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(8.0))),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Не предоставлены разрешения для загрузки файлов',
                  maxLines: 2,
                  style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ))
          ],
        ));
  }

  Future<void> downloadFileToDirectory(DownloadFileMaterial material) async {
    String basePath;
    if (Platform.isAndroid) {
      basePath = await ExtStorage.getExternalStoragePublicDirectory(
          ExtStorage.DIRECTORY_DOWNLOADS);
    } else {
      basePath = (await getApplicationDocumentsDirectory()).path;
    }

    widget.proxyBloc.eventController.add(
        FileStartDownloadEvent<MultipartRequestCommand>(
            command: material.command,
            file: LocalFilesystemObject.fromNameAndBase(
                basePath,
                widget.fileMaterial.originalFileName ??
                    base64UrlEncode(List<int>.generate(
                        10, (i) => (Random.secure()).nextInt(255))))));
  }
}
