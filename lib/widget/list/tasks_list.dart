import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/bloc/loader/loader_bloc.dart';
import 'package:lk_client/command/consume_command.dart';
import 'package:lk_client/event/consuming_event.dart';
import 'package:lk_client/model/discipline/discipline.dart';
import 'package:lk_client/model/discipline/student_work.dart';
import 'package:lk_client/model/education/education.dart';
import 'package:lk_client/model/education/semester.dart';
import 'package:lk_client/service/api_consumer/discipline_query_service.dart';
import 'package:lk_client/state/consuming_state.dart';
import 'package:lk_client/store/global/app_state_container.dart';
import 'package:lk_client/widget/chunk/centered_loader.dart';
import 'package:lk_client/widget/chunk/student_task_list_item.dart';

class TasksList extends StatefulWidget {
  final Education education;
  final Semester semester;
  final Discipline discipline;
  final TasksListLoaderBloc tasksListLoaderBloc;

  TasksList(
      {Key key,
      @required this.discipline,
      @required this.education,
      @required this.semester,
      @required this.tasksListLoaderBloc})
      : super(key: key);

  @override
  _TasksListState createState() => _TasksListState(this.tasksListLoaderBloc);
}

class _TasksListState extends State<TasksList> {
  TasksListLoaderBloc tasksListLoaderBloc;

  _TasksListState([this.tasksListLoaderBloc]);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (this.tasksListLoaderBloc == null) {
      DisciplineQueryService disciplineQueryService =
          AppStateContainer.of(context).serviceProvider.disciplineQueryService;
      this.tasksListLoaderBloc = TasksListLoaderBloc(disciplineQueryService);
    }
  }

  @override
  Widget build(BuildContext context) {
    this.tasksListLoaderBloc.eventController.sink.add(
        StartConsumeEvent<LoadTasksListCommand>(
            request: LoadTasksListCommand(
                discipline: widget.discipline,
                education: widget.education,
                semester: widget.semester)));

    return StreamBuilder(
        stream: this.tasksListLoaderBloc.consumingStateStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            ConsumingState<List<StudentWork>> state = snapshot.data;

            if (state is ConsumingErrorState<List<StudentWork>>) {
              return Center(child: Text('Ошибка загрузки списка заданий'));
            }

            if (state is ConsumingReadyState<List<StudentWork>>) {
              List<StudentWork> loadedStudentWorks = state.content;

              if (state.content.length == 0) {
                return Center(child: Text('Задания пока не добавлены'));
              }

              return Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                  child: ListView.separated(
                      itemCount: loadedStudentWorks.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          SizedBox(
                            height: 8.0,
                          ),
                      itemBuilder: (BuildContext context, int index) {
                        StudentWork sw = loadedStudentWorks[index];
                        return Container(
                            child: StudentTaskListItem(
                          studentWork: sw,
                          semester: widget.semester,
                          discipline: widget.discipline,
                          bloc: this.tasksListLoaderBloc,
                          education: widget.education,
                        ));
                      }));
            }
          }

          return CenteredLoader();
        });
  }
}
