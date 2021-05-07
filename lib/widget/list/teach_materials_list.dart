import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/bloc/loader_bloc.dart';
import 'package:lk_client/command/consume_command/discipline_request_command.dart';
import 'package:lk_client/event/consuming_event.dart';
import 'package:lk_client/model/discipline/discipline.dart';
import 'package:lk_client/model/discipline/teaching_material.dart';
import 'package:lk_client/model/education/education.dart';
import 'package:lk_client/model/education/semester.dart';
import 'package:lk_client/service/api_consumer/discipline_query_service.dart';
import 'package:lk_client/store/global/app_state_container.dart';
import 'package:lk_client/widget/chunk/stream_loading_widget.dart';

class TeachMaterialsList extends StatefulWidget {
  final Discipline discipline;
  final Education education;
  final Semester semester;

  TeachMaterialsList(
      {Key key,
      @required this.education,
      @required this.semester,
      @required this.discipline})
      : super(key: key);

  @override
  _TeachMaterialsListState createState() => _TeachMaterialsListState();
}

class _TeachMaterialsListState extends State<TeachMaterialsList> {
  TeachingMaterialListLoadingBloc _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (this._bloc == null) {
      DisciplineQueryService queryService =
          AppStateContainer.of(context).serviceProvider.disciplineQueryService;
      this._bloc = TeachingMaterialListLoadingBloc(queryService);
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
    this._bloc.eventController.sink.add(
        StartConsumeEvent<LoadTeachingMaterialsList>(
            request: LoadTeachingMaterialsList(
                discipline: widget.discipline,
                education: widget.education,
                semester: widget.semester)));
                
    return StreamLoadingWidget<List<TeachingMaterial>>(
      loadingStream: this._bloc.consumingStateStream,
      childBuilder: (List<TeachingMaterial> teachingMaterials) {
        return ListView.separated(
            itemBuilder: (BuildContext context, int index) {
              return Container(
                child: ListTile(
                  title: Text(teachingMaterials[index].materialName),
                  subtitle: Text(teachingMaterials[index].materialType),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) => Divider(),
            itemCount: teachingMaterials.length);
      },
    );
  }
}
