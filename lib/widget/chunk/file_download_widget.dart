import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/bloc/file_transfer_bloc.dart';
import 'package:lk_client/service/app_config.dart';
import 'package:lk_client/store/global/app_state_container.dart';
import 'package:lk_client/store/global/service_provider.dart';

class FileDownloadWidget extends StatefulWidget {
  FileDownloadWidget({Key key}) : super(key: key);

  @override
  _FileDownloadWidgetState createState() => _FileDownloadWidgetState();
}

class _FileDownloadWidgetState extends State<FileDownloadWidget> {
  TeachingMaterialDocumentTransferBloc _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(this._bloc == null) {
      final ServiceProvider provider = AppStateContainer.of(context).serviceProvider;
      this._bloc = TeachingMaterialDocumentTransferBloc(
        provider.appConfig, provider.fileLocalManager, provider.fileTransferService);
    }
  }
  @override
  Widget build(BuildContext context) {
    //this._bloc.eventController.sink.add();

    return Container(
      padding: EdgeInsets.all(5.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 50.0),
        child: Row(
          children: [
            GestureDetector(
              child: Container(
                padding: EdgeInsets.all(3.0),
                child: Column(
                  children: [
                    Icon(Icons.download_outlined),
                    Text('')
                  ],
                ),
              ),
              onTap: () {

              },
            ),
            Text('')
          ],
        ),
      ),
    );
  }
}
