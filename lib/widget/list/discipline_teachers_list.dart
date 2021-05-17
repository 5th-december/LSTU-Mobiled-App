import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/bloc/loader_bloc.dart';
import 'package:lk_client/command/consume_command.dart';
import 'package:lk_client/event/consuming_event.dart';
import 'package:lk_client/model/discipline/discipline.dart';
import 'package:lk_client/model/education/education.dart';
import 'package:lk_client/model/education/semester.dart';
import 'package:lk_client/model/education/timetable_item.dart';
import 'package:lk_client/service/api_consumer/discipline_query_service.dart';
import 'package:lk_client/store/global/app_state_container.dart';
import 'package:lk_client/widget/chunk/stream_loading_widget.dart';

class DisciplineTeachersList extends StatefulWidget {
  final Discipline discipline;
  final Education education;
  final Semester semester;

  DisciplineTeachersList(
      {Key key,
      @required this.discipline,
      @required this.education,
      @required this.semester})
      : super(key: key);

  @override
  _DisciplineTeachersListState createState() => _DisciplineTeachersListState();
}

class _DisciplineTeachersListState extends State<DisciplineTeachersList> {
  DisciplineTeachersListLoaderBloc _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (this._bloc == null) {
      DisciplineQueryService queryService =
          AppStateContainer.of(context).serviceProvider.disciplineQueryService;
      this._bloc = DisciplineTeachersListLoaderBloc(queryService);
    }
  }

  @override
  dispose() async {
    Future.delayed(Duration.zero, () async {
      await this._bloc.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    this._bloc.eventController.add(StartConsumeEvent<LoadDisciplineTeacherList>(
        request: LoadDisciplineTeacherList(
            discipline: widget.discipline,
            semester: widget.semester,
            education: widget.education)));

    return StreamLoadingWidget<List<TimetableItem>>(
      loadingStream: _bloc.consumingStateStream,
      childBuilder: (List<TimetableItem> argumentList) {
        return Column(
          children: List.generate(
              argumentList.length,
              (index) => Container(
                    child: ListTile(
                      /*trailing: PersonProfilePicture(
                          displayed: argumentList[index].teacher.person,
                          size: 36.0),*/
                      title: Text(
                          '${argumentList[index].teacher.person.surname} ${argumentList[index].teacher.person.name} ${argumentList[index].teacher.person.patronymic}'),
                      subtitle: Text(argumentList[index].lessonType),
                    ),
                  )),
        );
      },
    );
  }
}
