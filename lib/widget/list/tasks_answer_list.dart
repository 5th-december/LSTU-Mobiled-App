import 'package:flutter/widgets.dart';
import 'package:lk_client/model/discipline/work_answer_attachment.dart';
import 'package:lk_client/service/api_consumer/file_transfer_service.dart';
import 'package:lk_client/service/file_local_manager.dart';
import 'package:lk_client/service/notification/notifier.dart';
import 'package:lk_client/store/global/app_state_container.dart';
import 'package:lk_client/store/global/loader_provider.dart';
import 'package:lk_client/store/global/service_provider.dart';
import 'package:lk_client/widget/chunk/file_download_widget.dart';
import 'package:lk_client/widget/chunk/student_task_answer_list_item.dart';

class TasksAnswerList extends StatefulWidget {
  final List<WorkAnswerAttachment> answerAttachements;

  TasksAnswerList({Key key, @required this.answerAttachements})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _TasksAnswerListState();
}

class _TasksAnswerListState extends State<TasksAnswerList> {
  FileLocalManager _fileLocalManager;
  Notifier _appNotifier;
  FileTransferService _fileTransferService;
  FileDownloaderBlocProvider _fileDownloaderBlocProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    ServiceProvider serviceProvider =
        AppStateContainer.of(context).serviceProvider;

    if (this._fileLocalManager == null) {
      this._fileLocalManager = serviceProvider.fileLocalManager;
    }

    if (this._appNotifier == null) {
      this._appNotifier = serviceProvider.notifier;
    }

    if (this._fileTransferService == null) {
      this._fileTransferService = serviceProvider.fileTransferService;
    }

    if (this._fileDownloaderBlocProvider == null) {
      this._fileDownloaderBlocProvider =
          LoaderProvider.of(context).fileDownloaderBlocProvider;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
        child: ListView.separated(
            itemCount: widget.answerAttachements.length,
            separatorBuilder: (BuildContext context, int index) => SizedBox(
                  height: 8.0,
                ),
            itemBuilder: (BuildContext context, int index) {
              return StudentTaskAnswerListItem(
                  workAnswerAttachment: widget.answerAttachements[index],
                  appNotifier: this._appNotifier,
                  fileDownloaderBlocProvider: this._fileDownloaderBlocProvider,
                  fileLocalManager: this._fileLocalManager,
                  fileTransferService: this._fileTransferService);
            }));
  }
}
