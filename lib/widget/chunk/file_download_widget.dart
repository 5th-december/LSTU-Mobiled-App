import 'dart:io';

import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/bloc/attached/abstract_file_transfer_bloc.dart';
import 'package:lk_client/bloc/attached/file_transfer_bloc.dart';
import 'package:lk_client/command/consume_command.dart';
import 'package:lk_client/event/file_management_event.dart';
import 'package:lk_client/model/data_transfer/attachment.dart';
import 'package:lk_client/model/data_transfer/external_link.dart';
import 'package:lk_client/model/discipline/teaching_material.dart';
import 'package:lk_client/model/util/local_filesystem_object.dart';
import 'package:lk_client/state/file_management_state.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

// Доставляет контент в file download widget в независимом от типа запроса виде
abstract class DownloadMaterial {
  final AbstractFileTransferBloc bloc;
  DownloadMaterial({@required this.bloc});
}

class DownloadFileMaterial extends DownloadMaterial {
  final Attachment attachment;
  final MultipartRequestCommand command;
  DownloadFileMaterial(
      {@required this.attachment, @required bloc, @required this.command})
      : super(bloc: bloc);
}

class DownloadExternalLinkMaterial extends DownloadMaterial {
  final ExternalLink externalLink;
  DownloadExternalLinkMaterial({@required this.externalLink, @required bloc})
      : super(bloc: bloc);
}

class TeachingMaterialDownloadManagerCreator {
  /*
   * Создание подкласса DownloadMaterial из TeachingMatrial
   */
  static DownloadMaterial initialize(
      TeachingMaterial material, TeachingMaterialDocumentTransferBloc bloc) {
    /*
     * Если прикреплен файл
     */
    if (material.attachment != null) {
      LoadTeachingMaterialAttachment command =
          LoadTeachingMaterialAttachment(material.id);

      return DownloadFileMaterial(
          bloc: bloc, attachment: material.attachment, command: command);
    } else if (material.externalLink != null) {
      /*
       * Если прикреплена внешняя ссылка
       */
      return DownloadExternalLinkMaterial(
          bloc: bloc, externalLink: material.externalLink);
    }
    throw Exception('Undefined attachment type');
  }
}

class FileDownloadWidget extends StatefulWidget {
  final DownloadMaterial manager;

  FileDownloadWidget({Key key, @required this.manager}) : super(key: key);

  @override
  _FileDownloadWidgetState createState() => _FileDownloadWidgetState();
}

Future<void> downloadFileToDirectory(DownloadMaterial manager) async {
  String basePath;
  if (Platform.isAndroid) {
    basePath = await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DOWNLOADS);
  } else {
    basePath = (await getApplicationDocumentsDirectory()).path;
  }

  manager.bloc.eventController.add(
      FileStartDownloadEvent<MultipartRequestCommand>(
          command: (manager as DownloadFileMaterial).command,
          file: LocalFilesystemObject.fromFilePath(basePath)));
}

class _FileDownloadWidgetState extends State<FileDownloadWidget> {
  DownloadMaterial get manager => widget.manager;

  @override
  Widget build(BuildContext context) {
    this.manager.bloc.eventController.add(FileManagementInitEvent());

    if (manager is DownloadFileMaterial) {
      final _manager = (manager as DownloadFileMaterial);

      String fileExtension =
          _manager.attachment.attachmentName.split('.')?.last ?? '';
      double fileSize = double.parse(_manager.attachment.attachmentSize);
      String sizeTitle = fileSize > 1024
          ? (fileSize / 1024).toStringAsFixed(2) + ' Мб.'
          : fileSize.toStringAsFixed(2) + ' Кб.';

      return StreamBuilder(
          stream: this.manager.bloc.binaryTransferStateStream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              FileManagementState state =
                  (snapshot.data) as FileManagementState;
              /*
               * В случае начальной инициализации при нажатии на кнопку загрузки
               * определяется директория сохранения и отправляется event на скачивание файла
               */
              if (state is FileManagementInitState) {
                return ConstrainedBox(
                    constraints:
                        BoxConstraints(maxWidth: 150.0, minWidth: 150.0),
                    child: Row(
                      children: [
                        ElevatedButton(
                            onPressed: () =>
                                downloadFileToDirectory(this.manager),
                            child: Icon(Icons.download_rounded, size: 24.0),
                            style: ElevatedButton.styleFrom(
                                shape: CircleBorder())),
                        Expanded(
                            child: Column(
                          children: [
                            Text(_manager.attachment.attachmentName),
                            Text('$fileExtension $sizeTitle')
                          ],
                        ))
                      ],
                    ));
              }

              if (state is FileManagementRightsErrorState) {
                return ConstrainedBox(
                    constraints:
                        BoxConstraints(maxWidth: 150.0, minWidth: 150.0),
                    child: Row(
                      children: [
                        ElevatedButton(
                            onPressed: () => {},
                            child:
                                Icon(Icons.warning_amber_rounded, size: 24.0),
                            style: ElevatedButton.styleFrom(
                                shape: CircleBorder())),
                        Expanded(
                            child: Column(
                          children: [
                            Text('Не предоставлены разрешения', maxLines: 2),
                          ],
                        ))
                      ],
                    ));
              }

              if (state is FileOperationProgressState) {
                int percent = ((state.rate /
                            1024.0 *
                            double.parse((manager as DownloadFileMaterial)
                                .attachment
                                .attachmentSize)) *
                        100.0)
                    .round();
                return ConstrainedBox(
                    constraints:
                        BoxConstraints(maxWidth: 150.0, minWidth: 150.0),
                    child: Row(
                      children: [
                        ElevatedButton(
                            onPressed: () => {},
                            child: Text('$percent %'),
                            style: ElevatedButton.styleFrom(
                                shape: CircleBorder())),
                        Expanded(
                            child: Column(
                          children: [
                            Text('Загружается...', maxLines: 1),
                          ],
                        ))
                      ],
                    ));
              }

              if (state is FileOperationErrorState) {
                return ConstrainedBox(
                    constraints:
                        BoxConstraints(maxWidth: 150.0, minWidth: 150.0),
                    child: Row(
                      children: [
                        ElevatedButton(
                            onPressed: () =>
                                downloadFileToDirectory(this.manager),
                            child:
                                Icon(Icons.error_outline_rounded, size: 24.0),
                            style: ElevatedButton.styleFrom(
                                shape: CircleBorder())),
                        Expanded(
                            child: Column(
                          children: [
                            Text(_manager.attachment.attachmentName),
                            Text('$fileExtension $sizeTitle'),
                            Text('Произошла ошибка')
                          ],
                        ))
                      ],
                    ));
              }

              if (state is FileDownloadReadyState) {
                return ConstrainedBox(
                    constraints:
                        BoxConstraints(maxWidth: 150.0, minWidth: 150.0),
                    child: Row(
                      children: [
                        ElevatedButton(
                            onPressed: () => {},
                            child:
                                Icon(Icons.download_done_rounded, size: 24.0),
                            style: ElevatedButton.styleFrom(
                                shape: CircleBorder())),
                        Expanded(
                            child: Column(
                          children: [
                            Text(_manager.attachment.attachmentName),
                            Text('$fileExtension $sizeTitle')
                          ],
                        ))
                      ],
                    ));
              }
            }

            return SizedBox.shrink();
          });
    } else if (manager is DownloadExternalLinkMaterial) {
      return TextButton(
        onPressed: () async {
          final String link = (manager as DownloadExternalLinkMaterial)
              .externalLink
              .linkContent;
          await canLaunch(link)
              ? await launch(link)
              : throw Exception('Can not open link');
        },
        child: Icon(Icons.open_in_browser_outlined),
      );
    } else {
      return FlutterLogo();
    }
  }
}
