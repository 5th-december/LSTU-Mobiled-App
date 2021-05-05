import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/bloc/loader_bloc.dart';
import 'package:lk_client/model/discipline/discipline.dart';
import 'package:lk_client/model/education/education.dart';
import 'package:lk_client/model/education/semester.dart';
import 'package:lk_client/model/education/timetable_item.dart';
import 'package:lk_client/service/api_consumer/discipline_query_service.dart';
import 'package:lk_client/store/global/app_state_container.dart';
import 'package:lk_client/widget/chunk/list_widget.dart';
import 'package:lk_client/widget/layout/profile_picture.dart';

class DisciplineTeachersList extends StatefulWidget {
  DisciplineTeachersList(
    {Key key, @required Discipline discipline, @required Education education, 
      @required Semester semester}):super(key: key);

  @override
  _DisciplineTeachersListState createState() => _DisciplineTeachersListState();
}

class _DisciplineTeachersListState extends State<DisciplineTeachersList> {
  DisciplineTeachersListLoaderBloc _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(this._bloc == null) {
      DisciplineQueryService queryService = AppStateContainer.of(context).serviceProvider.disciplineQueryService;
      this._bloc = DisciplineTeachersListLoaderBloc(queryService);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListWidget<TimetableItem>(
      loadingStream: _bloc.consumingStateStream,
      listBuilder: (List<TimetableItem> argumentList) {
        return Column(
          children: List.generate(
            argumentList.length, (index) => Card(
              child: ListTile(
                trailing: PersonProfilePicture(displayed: argumentList[index].teacher.person, size: 36.0),
                title: Text('${argumentList[index].teacher.person.surname} ${argumentList[index].teacher.person.name} ${argumentList[index].teacher.person.patronymic}'),
                subtitle: Text(argumentList[index].lessonType),
              ),
            )
          ),
        );
      },
    );
  }
}