import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/bloc/attached/file_transfer_bloc.dart';
import 'package:lk_client/bloc/attached/single_type_attachment_form_bloc.dart';
import 'package:lk_client/bloc/attached/work_attachment_form_bloc.dart';
import 'package:lk_client/bloc/proxy/discussion_message_form_transport_proxy_bloc.dart';
import 'package:lk_client/bloc/proxy/task_response_form_transport_proxy_bloc.dart';
import 'package:lk_client/command/produce_command.dart';
import 'package:lk_client/event/attached_form_event.dart';
import 'package:lk_client/model/discipline/student_work.dart';
import 'package:lk_client/model/discipline/work_answer_attachment.dart';
import 'package:lk_client/model/education/education.dart';
import 'package:lk_client/service/api_consumer/discipline_query_service.dart';
import 'package:lk_client/service/api_consumer/file_transfer_service.dart';
import 'package:lk_client/service/api_consumer/messenger_query_service.dart';
import 'package:lk_client/store/global/app_state_container.dart';
import 'package:lk_client/store/global/attached_bloc_provider.dart';
import 'package:lk_client/store/global/loader_provider.dart';
import 'package:lk_client/widget/form/attached_private_messaging_form.dart';
import 'package:lk_client/widget/form/attached_student_tasks_response_form.dart';

class TaskResponsePage extends StatefulWidget {
  final StudentWork studentWork;

  final Education education;

  TaskResponsePage(
      {Key key, @required this.studentWork, @required this.education});

  @override
  State<TaskResponsePage> createState() => TaskResponsePageState();
}

class TaskResponsePageState extends State<TaskResponsePage> {
  FileTransferService _fileTransferService;

  DisciplineQueryService _disciplineQueryService;

  AttachedBlocProvider _attachedBlocProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final serviceProvider = AppStateContainer.of(context).serviceProvider;

    if (this._fileTransferService == null) {
      this._fileTransferService = serviceProvider.fileTransferService;
    }

    if (this._disciplineQueryService == null) {
      this._disciplineQueryService = serviceProvider.disciplineQueryService;
    }

    if (this._attachedBlocProvider == null) {
      this._attachedBlocProvider =
          LoaderProvider.of(context).attachedBlocProvider;
    }
  }

  @override
  Widget build(BuildContext context) {
    final workAttachmentObjectBuilder = WorkAnswerAttachmentFormObjectBuilder();

    final formBloc = SingleTypeAttachementFormBloc<WorkAnswerAttachment>(
        workAttachmentObjectBuilder);

    return Scaffold(
      appBar: AppBar(
        title: Text('Ответ на задание'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
            child: Column(
              children: [
                StudentTaskResponseForm(
                    formBloc: formBloc,
                    controllerProvider: workAttachmentObjectBuilder,
                    transportProxyBloc: TaskResponseFormTransportProxyBloc(
                        formBloc: formBloc,
                        workAnswerAttachmentSendDocumentTransferBloc:
                            WorkAnswerAttachmentSendDocumentTransferBloc(
                                fileTransferService: this._fileTransferService),
                        workAttachmentFormBloc: WorkAttachmentFormBloc(
                            disciplineQueryService:
                                this._disciplineQueryService),
                        sendingCommand: SendWorkAnswerAttachment(
                            studentWork: widget.studentWork,
                            education: widget.education),
                        attachedBlocProvider: this._attachedBlocProvider)),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: StreamBuilder(
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return ElevatedButton(
                  onPressed: () => formBloc.eventController.sink
                      .add(PrepareFormObjectEvent()),
                  child: Text('Отправить'),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
