import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/bloc/education_details_bloc.dart';
import 'package:lk_client/command/consume_command/education_request_command.dart';
import 'package:lk_client/event/consuming_event.dart';
import 'package:lk_client/model/education/education.dart';
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/service/api_consumer/education_query_service.dart';
import 'package:lk_client/state/consuming_state.dart';
import 'package:lk_client/store/global/app_state_container.dart';

class EducationDetails extends StatefulWidget {
  final Person _person;

  EducationDetails(this._person);

  @override
  _EducationDetailsState createState() => _EducationDetailsState();
}

class _EducationDetailsState extends State<EducationDetails> {
  EducationDetailsBloc _educationDetailsBloc;

  Person get _person => widget._person;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_educationDetailsBloc == null) {
      EducationQueryService appEducationQueryService =
          AppStateContainer.of(context).serviceProvider.educationQueryService;
      this._educationDetailsBloc =
          new EducationDetailsBloc(appEducationQueryService);
    }
  }

  @override
  dispose() async {
    Future.delayed(Duration.zero, () async {
      await this._educationDetailsBloc.dispose();
    });
    super.dispose();
  }

  Widget _buildEducationDetailsView(List<Education> educationsList) {
    if (educationsList.length == 1) {
      return Column(
        children: [
          Divider(),
          Text('${educationsList[0].group.speciality.specName}'),
          Text(
              'Квалификация: ${educationsList[0].group.speciality.qualification}'),
          Text('Статус: ${educationsList[0].status}'),
          Text('Период обучения: ${educationsList[0].status}')
        ],
      );
    } else {
      return Column(
        children: () {
          List<Widget> educationViewGroups = [Divider()];

          for (var educationItem in educationsList) {
            educationViewGroups.add(Text(
                '${educationItem.group.speciality.specName}, ${educationItem.group.speciality.specName}'));
          }

          return educationViewGroups;
        }(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    this._educationDetailsBloc.eventController.sink.add(
        StartConsumeEvent<LoadCurrentEducationsCommand>(
            request: LoadCurrentEducationsCommand(this._person)));
    return StreamBuilder(
      stream: this._educationDetailsBloc.educationDetailsStateStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData &&
            snapshot.data is ConsumingReadyState<List<Education>>) {
          List<Education> currentEducationList =
              (snapshot.data as ConsumingReadyState<List<Education>>).content;

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
