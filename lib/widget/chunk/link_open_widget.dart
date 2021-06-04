import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/widget/chunk/file_download_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkOpenWidget extends StatelessWidget {
  final DownloadExternalLinkMaterial externalLink;

  LinkOpenWidget({Key key, @required this.externalLink});

  @override
  Widget build(BuildContext context) {
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
                onPressed: () async {
                  final String link =
                      this.externalLink.externalLink.linkContent;
                  await canLaunch(link)
                      ? await launch(link)
                      : throw Exception('Can not open link');
                },
                child: Icon(Icons.public_rounded, size: 32.0),
                style: ElevatedButton.styleFrom(
                    primary: Color.fromRGBO(139, 62, 252, 1.0),
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(8.0))),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Внешняя ссылка',
                  maxLines: 2,
                  style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 3.0),
                Text(
                  'Откроется в браузере',
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
}
