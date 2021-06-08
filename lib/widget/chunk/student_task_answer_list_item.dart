import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/command/consume_command.dart';
import 'package:lk_client/model/data_transfer/attachment.dart';
import 'package:lk_client/model/data_transfer/external_link.dart';
import 'package:lk_client/model/discipline/work_answer_attachment.dart';
import 'package:lk_client/service/api_consumer/file_transfer_service.dart';
import 'package:lk_client/service/file_local_manager.dart';
import 'package:lk_client/service/notification/notifier.dart';
import 'package:lk_client/widget/chunk/file_download_widget.dart';
import 'package:lk_client/widget/chunk/link_open_widget.dart';

class StudentTaskAnswerListItem extends StatelessWidget {
  final WorkAnswerAttachment workAnswerAttachment;
  final FileLocalManager fileLocalManager;
  final Notifier appNotifier;
  final FileTransferService fileTransferService;
  final FileDownloaderBlocProvider fileDownloaderBlocProvider;

  StudentTaskAnswerListItem(
      {Key key,
      @required this.workAnswerAttachment,
      @required this.appNotifier,
      @required this.fileDownloaderBlocProvider,
      @required this.fileLocalManager,
      @required this.fileTransferService})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: Column(
        children: [
          Row(
            children: [
              Text(this.workAnswerAttachment.name ?? 'Материал ответа',
                  style: TextStyle(fontSize: 18.0, color: Colors.grey.shade800))
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: () {
              List<Widget> actionWidgets = <Widget>[];
              if (this.workAnswerAttachment.attachments != null &&
                  this.workAnswerAttachment.attachments.length != 0) {
                Attachment answerAttachment =
                    this.workAnswerAttachment.attachments[0];
                actionWidgets.add(FileDownloadWidget(
                  fileMaterial: DownloadFileMaterial(
                      originalFileName: answerAttachment.attachmentName,
                      attachmentId: this.workAnswerAttachment.id,
                      attachment: answerAttachment,
                      command: LoadStudentTaskAnswerMaterialAttachment(
                          studentTaskAnswerMaterial:
                              this.workAnswerAttachment)),
                  proxyBloc: StudentTaskAnswerDownloaderProxyBloc(
                      fileDownloaderBlocProvider:
                          this.fileDownloaderBlocProvider,
                      fileLocalManager: this.fileLocalManager,
                      fileTransferService: this.fileTransferService,
                      appNotifier: this.appNotifier),
                ));
              } else if (this.workAnswerAttachment.extLinks != null &&
                  this.workAnswerAttachment.extLinks.length != 0) {
                ExternalLink externalLink =
                    this.workAnswerAttachment.extLinks[0];
                actionWidgets.add(LinkOpenWidget(
                  externalLink: DownloadExternalLinkMaterial(
                      externalLink: ExternalLink(
                          linkContent: externalLink.linkContent,
                          linkText: externalLink.linkText)),
                ));
              }
              return actionWidgets;
            }(),
          )
        ],
      ),
    );
  }
}
