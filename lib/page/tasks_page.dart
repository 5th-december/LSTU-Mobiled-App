import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/bloc/loader/loader_bloc.dart';
import 'package:lk_client/model/discipline/discipline.dart';
import 'package:lk_client/model/education/education.dart';
import 'package:lk_client/model/education/semester.dart';
import 'package:lk_client/service/api_consumer/discipline_query_service.dart';
import 'package:lk_client/store/global/app_state_container.dart';
import 'package:lk_client/widget/list/tasks_list.dart';

class TasksPage extends StatefulWidget {
  final Education education;
  final Semester semester;
  final Discipline discipline;

  TasksPage(
      {Key key,
      @required this.discipline,
      @required this.education,
      @required this.semester})
      : super(key: key);

  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  TasksListLoaderBloc tasksListLoaderBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (this.tasksListLoaderBloc == null) {
      DisciplineQueryService disciplineQueryService =
          AppStateContainer.of(context).serviceProvider.disciplineQueryService;
      this.tasksListLoaderBloc = TasksListLoaderBloc(disciplineQueryService);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Задания')),
      body: TasksList(
          discipline: widget.discipline,
          education: widget.education,
          semester: widget.semester,
          tasksListLoaderBloc: this.tasksListLoaderBloc),
    );
  }
}
