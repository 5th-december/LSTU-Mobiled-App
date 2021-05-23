import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/widget/chunk/file_download_widget.dart';

class FileListItem extends StatelessWidget {
  final String fileDataName;
  final String fileSubname;
  final String fileType;
  final String fileSize;
  final FileDownloadWidget fileDownloadWidget;

  FileListItem(
      {Key key,
      @required this.fileDataName,
      this.fileSize,
      this.fileSubname,
      this.fileType,
      @required this.fileDownloadWidget});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: () {
              List<Widget> fileListItemData = <Widget>[];

              fileListItemData.add(Text(this.fileDataName,
                  maxLines: 3,
                  style:
                      TextStyle(fontSize: 18.0, color: Colors.grey.shade800)));

              fileListItemData.add(SizedBox(height: 10.0));

              if (this.fileSubname != null) {
                fileListItemData.add(Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.description_rounded,
                        size: 16.0, color: Colors.grey.shade400),
                    Text(this.fileSubname,
                        style: TextStyle(
                            fontSize: 14.0, color: Colors.grey.shade400))
                  ],
                ));
              }

              fileListItemData.add(Row(
                children: () {
                  List<Widget> filePropertiesData = <Widget>[];

                  if (this.fileSubname != null) {
                    filePropertiesData.add(Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.description_rounded,
                            size: 16.0, color: Colors.grey.shade400),
                        SizedBox(width: 12.0),
                        Text(this.fileSubname,
                            style: TextStyle(
                                fontSize: 14.0, color: Colors.grey.shade400))
                      ],
                    ));
                  }

                  if (this.fileSubname != null) {
                    filePropertiesData.add(SizedBox(width: 20.0));
                    filePropertiesData.add(Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.description_rounded,
                            size: 16.0, color: Colors.grey.shade400),
                        SizedBox(width: 12.0),
                        Text(this.fileSubname,
                            style: TextStyle(
                                fontSize: 14.0, color: Colors.grey.shade400))
                      ],
                    ));
                  }
                }(),
              ));
            }(),
          )),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [this.fileDownloadWidget],
          )
        ],
      ),
    );
  }
}
