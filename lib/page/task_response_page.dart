import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/bloc/attached/file_transfer_bloc.dart';
import 'package:lk_client/bloc/attached/single_type_attachment_form_bloc.dart';
import 'package:lk_client/bloc/attached/work_attachment_form_bloc.dart';
import 'package:lk_client/bloc/loader/loader_bloc.dart';
import 'package:lk_client/bloc/proxy/discussion_message_form_transport_proxy_bloc.dart';
import 'package:lk_client/bloc/proxy/task_response_form_transport_proxy_bloc.dart';
import 'package:lk_client/command/consume_command.dart';
import 'package:lk_client/command/produce_command.dart';
import 'package:lk_client/event/attached_form_event.dart';
import 'package:lk_client/event/consuming_event.dart';
import 'package:lk_client/model/discipline/discipline.dart';
import 'package:lk_client/model/discipline/student_work.dart';
import 'package:lk_client/model/discipline/work_answer_attachment.dart';
import 'package:lk_client/model/education/education.dart';
import 'package:lk_client/model/education/semester.dart';
import 'package:lk_client/service/api_consumer/discipline_query_service.dart';
import 'package:lk_client/service/api_consumer/file_transfer_service.dart';
import 'package:lk_client/service/api_consumer/messenger_query_service.dart';
import 'package:lk_client/state/producing_state.dart';
import 'package:lk_client/store/global/app_state_container.dart';
import 'package:lk_client/store/global/attached_bloc_provider.dart';
import 'package:lk_client/store/global/loader_provider.dart';
import 'package:lk_client/widget/form/attached_private_messaging_form.dart';
import 'package:lk_client/widget/form/attached_student_tasks_response_form.dart';

class TaskResponsePage extends StatefulWidget {
  final StudentWork studentWork;

  final Education education;

  final Discipline discipline;

  final Semester semester;

  final TasksListLoaderBloc loaderBloc;

  TaskResponsePage(
      {Key key,
      @required this.studentWork,
      @required this.discipline,
      @required this.semester,
      @required this.education,
      @required this.loaderBloc});

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

    final transportProxyBloc = TaskResponseFormTransportProxyBloc(
        formBloc: formBloc,
        workAnswerAttachmentSendDocumentTransferBloc:
            WorkAnswerAttachmentSendDocumentTransferBloc(
                fileTransferService: this._fileTransferService),
        workAttachmentFormBloc: WorkAttachmentFormBloc(
            disciplineQueryService: this._disciplineQueryService),
        sendingCommand: SendWorkAnswerAttachment(
            studentWork: widget.studentWork, education: widget.education),
        attachedBlocProvider: this._attachedBlocProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Ответ на задание'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
                top: 40.0, left: 20.0, right: 20.0, bottom: 20.0),
            child: Column(
              children: [
                StudentTaskResponseForm(
                    formBloc: formBloc,
                    controllerProvider: workAttachmentObjectBuilder,
                    transportProxyBloc: transportProxyBloc),
              ],
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                  padding: EdgeInsets.only(bottom: 80),
                  child: StreamBuilder(
                      stream: transportProxyBloc.attachedFormStateStream,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data is ProducingLoadingState) {
                            return CircularProgressIndicator();
                          } else if (snapshot.data is ProducingErrorState) {
                            return Text('Произошла ошибка');
                          } else if (snapshot.data is ProducingReadyState) {
                            widget.loaderBloc.eventController.sink.add(
                                StartConsumeEvent<LoadTasksListCommand>(
                                    request: LoadTasksListCommand(
                                        discipline: widget.discipline,
                                        education: widget.education,
                                        semester: widget.semester)));
                            Future.delayed(Duration(seconds: 1), () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            });
                            return Container(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.done,
                                    size: 32.0,
                                    color: Color.fromRGBO(137, 64, 253, 1.0),
                                  ),
                                  SizedBox(
                                    width: 12.0,
                                  ),
                                  Text(
                                    'Успешно',
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        color:
                                            Color.fromRGBO(137, 64, 253, 1.0)),
                                  )
                                ],
                              ),
                            );
                          }
                        }
                        return SizedBox.shrink();
                      }))),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
                padding: EdgeInsets.only(bottom: 16.0),
                child: ElevatedButton(
                  onPressed: () => formBloc.eventController.sink
                      .add(PrepareFormObjectEvent()),
                  child: Text('Отправить'),
                )),
          )
        ],
      ),
    );
  }
}
