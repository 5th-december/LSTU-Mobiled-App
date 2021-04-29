import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/bloc/education/education_details_bloc.dart';
import 'package:lk_client/event/content_event.dart';
import 'package:lk_client/event/request_command/education_request_command.dart';
import 'package:lk_client/model/education/education.dart';
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/service/api_consumer/education_query_service.dart';
import 'package:lk_client/state/content_state.dart';
import 'package:lk_client/store/app_state_container.dart';

class EducationDetailsWidget extends StatefulWidget {
  final Person _person;

  EducationDetailsWidget(this._person);

  @override
  _EducationDetailsWidgetState createState() => _EducationDetailsWidgetState();
}

class _EducationDetailsWidgetState extends State<EducationDetailsWidget> {
  EducationDetailsBloc _educationDetailsBloc;

  Person get _person => widget._person;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(_educationDetailsBloc == null) {
      EducationQueryService appEducationQueryService = AppStateContainer.of(context).serviceProvider.educationQueryService;
      this._educationDetailsBloc = new EducationDetailsBloc(appEducationQueryService);
    }
  }

  Widget _buildEducationDetailsView(List<Education> educationsList) {
    if(educationsList.length == 1) {
      return Column(
        children: [
          Divider(),
          Text('${educationsList[0].group.speciality.specName}'),
          Text('Квалификация: ${educationsList[0].group.speciality.qualification}'),
          Text('Статус: ${educationsList[0].status}'),
          Text('Период обучения: ${educationsList[0].status}')
        ],
      );
    } else {
      return Column(
        children: () {
          List<Widget> educationViewGroups = [
            Divider()
          ];

          for(var educationItem in educationsList) {
            educationViewGroups.add(Text('${educationItem.group.speciality.specName}, ${educationItem.group.speciality.specName}'));
          }

          return educationViewGroups;
        }(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    this._educationDetailsBloc.eventController.sink.add(StartLoadingContentEvent<LoadCurrentEducationsCommand>(LoadCurrentEducationsCommand(this._person)));
    return StreamBuilder(
      stream: this._educationDetailsBloc.educationDetailsStateStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData && snapshot.data is ContentReadyState<List<Education>>) {
          List<Education> currentEducationList = (snapshot.data as ContentReadyState<List<Education>>).content;

          return this._buildEducationDetailsView(currentEducationList);
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
