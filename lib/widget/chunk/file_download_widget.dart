import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/bloc/attached/file_transfer_bloc.dart';
import 'package:lk_client/command/consume_command.dart';
import 'package:lk_client/event/file_management_event.dart';
import 'package:lk_client/model/discipline/teaching_material.dart';
import 'package:lk_client/model/util/local_filesystem_object.dart';
import 'package:lk_client/state/file_management_state.dart';
import 'package:lk_client/store/global/app_state_container.dart';
import 'package:lk_client/store/global/service_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class FileDownloadWidget extends StatefulWidget {
  final TeachingMaterial material;

  FileDownloadWidget({Key key, @required this.material}) : super(key: key);

  @override
  _FileDownloadWidgetState createState() => _FileDownloadWidgetState();
}

class _FileDownloadWidgetState extends State<FileDownloadWidget> {
  TeachingMaterialDocumentTransferBloc _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (this._bloc == null) {
      final ServiceProvider provider =
          AppStateContainer.of(context).serviceProvider;
      this._bloc = TeachingMaterialDocumentTransferBloc(provider.appConfig,
          provider.fileLocalManager, provider.fileTransferService);
    }
  }

  @override
  Widget build(BuildContext context) {
    this._bloc.eventController.add(FileManagementInitEvent());

    if (widget.material.attachment != null) {
      return StreamBuilder(
          stream: this._bloc.binaryTransferStateStream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              FileManagementState state =
                  (snapshot.data) as FileManagementState;

              if (state is FileManagementInitState) {
                return TextButton(
                  onPressed: () async {
                    String basePath =
                        await FilePicker.platform.getDirectoryPath();
                    this._bloc.eventController.add(FileFindInDirectoryEvent(
                        basePath: basePath,
                        fileName: widget.material.attachment.attachmentName));
                  },
                  child: Icon(Icons.download_outlined),
                );
              } else if (state is FileUnlocatedState) {
                this._bloc.eventController.add(
                    FileStartDownloadEvent<LoadTeachingMaterialAttachment>(
                        command:
                            LoadTeachingMaterialAttachment(widget.material.id),
                        file: LocalFilesystemObject.fromFilePath(state.filePath)));
              } else if (state is FileOperationProgressState) {
                int percent = ((state.rate /
                            1024.0 *
                            double.parse(
                                widget.material.attachment.attachmentSize)) *
                        100.0)
                    .round();
                return Text("$percent%");
              } else if (state is FileOperationErrorState) {
                return Icon(Icons.error_outlined);
              } else if (state is FileDownloadReadyState) {
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
    } else if (widget.material.externalLink != null) {
      return TextButton(
        onPressed: () async {
          final String link = widget.material.externalLink.linkContent;
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
