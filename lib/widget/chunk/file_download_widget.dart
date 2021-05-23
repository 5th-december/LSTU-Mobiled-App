import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/bloc/attached/abstract_file_transfer_bloc.dart';
import 'package:lk_client/bloc/attached/file_transfer_bloc.dart';
import 'package:lk_client/event/file_management_event.dart';
import 'package:lk_client/model/data_transfer/attachment.dart';
import 'package:lk_client/model/data_transfer/external_link.dart';
import 'package:lk_client/model/discipline/teaching_material.dart';
import 'package:lk_client/state/file_management_state.dart';
import 'package:url_launcher/url_launcher.dart';

// Доставляет контент в file download widget в независимом от типа запроса виде
abstract class DownloadMaterial {
  final AbstractFileTransferBloc bloc;
  DownloadMaterial({@required this.bloc});
}

class DownloadFileMaterial extends DownloadMaterial {
  final Attachment attachment;
  DownloadFileMaterial({@required this.attachment, @required bloc})
      : super(bloc: bloc);
}

class DownloadExternalLinkMaterial extends DownloadMaterial {
  final ExternalLink externalLink;
  DownloadExternalLinkMaterial({@required this.externalLink, @required bloc})
      : super(bloc: bloc);
}

class TeachingMaterialDownloadManagerCreator {
  static DownloadMaterial initialize(
      TeachingMaterial material, TeachingMaterialDocumentTransferBloc bloc) {
    if (material.attachment != null) {
      return DownloadFileMaterial(bloc: bloc, attachment: material.attachment);
    } else if (material.externalLink != null) {
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

class _FileDownloadWidgetState extends State<FileDownloadWidget> {
  DownloadMaterial get manager => widget.manager;

  @override
  Widget build(BuildContext context) {
    this.manager.bloc.eventController.add(FileManagementInitEvent());

    if (manager is DownloadFileMaterial) {
      return StreamBuilder(
          stream: this.manager.bloc.binaryTransferStateStream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              FileManagementState state =
                  (snapshot.data) as FileManagementState;

              if (state is FileManagementInitState) {
                return TextButton(
                  onPressed: () async {
                    String basePath =
                        await FilePicker.platform.getDirectoryPath();
                    this.manager.bloc.eventController.add(
                        FileFindInDirectoryEvent(
                            basePath: basePath,
                            fileName: (manager as DownloadFileMaterial)
                                .attachment
                                .attachmentName));
                  },
                  child: Icon(Icons.download_outlined),
                );
              }

              if (state is FileOperationProgressState) {
                int percent = ((state.rate /
                            1024.0 *
                            double.parse((manager as DownloadFileMaterial)
                                .attachment
                                .attachmentSize)) *
                        100.0)
                    .round();
                return Text("$percent%");
              }

              if (state is FileOperationErrorState) {
                return Icon(Icons.error_outlined);
              }

              if (state is FileDownloadReadyState) {
                return TextButton(
                  onPressed: () async {
                    return;
                  },
                  child: Icon(Icons.done_outline_outlined),
                );
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
