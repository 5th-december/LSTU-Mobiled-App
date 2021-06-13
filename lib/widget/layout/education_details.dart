import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:lk_client/bloc/loader/loader_bloc.dart';
import 'package:lk_client/command/consume_command.dart';
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
  EducationListLoaderBloc _bloc;

  Person get _person => widget._person;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_bloc == null) {
      EducationQueryService appEducationQueryService =
          AppStateContainer.of(context).serviceProvider.educationQueryService;
      this._bloc = EducationListLoaderBloc(appEducationQueryService);
    }
  }

  @override
  dispose() async {
    Future.delayed(Duration.zero, () async {
      await this._bloc.dispose();
    });
    super.dispose();
  }

  Widget _buildEducationDetailsView(List<Education> educationsList) {
    List<Widget> educationWidgetList = <Widget>[];
    for (Education education in educationsList) {
      educationWidgetList.add(Row(children: [
        Expanded(
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8.0))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.school_rounded),
                        SizedBox(
                          width: 16.0,
                        ),
                        Expanded(
                          child: Text(
                            'Направление: ${education.group.speciality.specName.toLowerCase()}',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        Icon(Icons.construction_rounded),
                        SizedBox(
                          width: 16.0,
                        ),
                        Expanded(
                          child: Text(
                            'Квалификация: ${education.group.speciality.qualification.toLowerCase()}',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        Icon(Icons.bolt),
                        SizedBox(
                          width: 16.0,
                        ),
                        Expanded(
                          child: Text(
                            'Статус: ${education.status.toLowerCase()}',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        Icon(Icons.calendar_today_rounded),
                        SizedBox(
                          width: 16.0,
                        ),
                        Expanded(
                          child: Text(
                            () {
                              DateFormat formatter = DateFormat('MM.yyyy');
                              final admissionDate = education.group.admission;
                              final admissionString = admissionDate != null
                                  ? formatter.format(admissionDate)
                                  : '?';
                              final graduationDate = education.group.graduation;
                              final graduationString = graduationDate != null
                                  ? formatter.format(graduationDate)
                                  : '?';
                              return 'Период обучения: $admissionString - $graduationString';
                            }(),
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        )
                      ],
                    ),
                  ],
                )))
      ]));
    }
    return Column(children: educationWidgetList);
  }

  @override
  Widget build(BuildContext context) {
    this._bloc.eventController.sink.add(
        StartConsumeEvent<LoadUserEducationListCommand>(
            request: LoadUserEducationListCommand(this._person)));
    return StreamBuilder(
      stream: this._bloc.consumingStateStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData &&
            snapshot.data is ConsumingReadyState<List<Education>>) {
          List<Education> currentEducationList =
              (snapshot.data as ConsumingReadyState<List<Education>>).content;

          return this._buildEducationDetailsView(currentEducationList);
        }
        return SizedBox.shrink();
      },
    );
  }
}
