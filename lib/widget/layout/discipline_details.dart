import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/bloc/loader/loader_bloc.dart';
import 'package:lk_client/command/consume_command.dart';
import 'package:lk_client/event/consuming_event.dart';
import 'package:lk_client/model/discipline/discipline.dart';
import 'package:lk_client/service/api_consumer/discipline_query_service.dart';
import 'package:lk_client/store/global/app_state_container.dart';
import 'package:lk_client/widget/chunk/stream_loading_widget.dart';

class DisciplineDetails extends StatefulWidget {
  final Discipline discipline;

  DisciplineDetails({Key key, @required this.discipline}) : super(key: key);

  @override
  _DisciplineDetailsState createState() => _DisciplineDetailsState();
}

class _DisciplineDetailsState extends State<DisciplineDetails> {
  DisciplineDetailsLoaderBloc _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (this._bloc == null) {
      DisciplineQueryService queryService =
          AppStateContainer.of(context).serviceProvider.disciplineQueryService;
      this._bloc = DisciplineDetailsLoaderBloc(queryService);
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
    this._bloc.eventController.add(StartConsumeEvent<LoadDisciplineDetails>(
        request: LoadDisciplineDetails(discipline: widget.discipline)));

    return StreamLoadingWidget<Discipline>(
        loadingStream: this._bloc.consumingStateStream,
        childBuilder: (Discipline disciplineDetails) {
          return Container(
            padding: EdgeInsets.only(top: 20.0, left: 12.0, right: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(disciplineDetails.name,
                    style: Theme.of(context).textTheme.headline2),
                Padding(
                  padding: EdgeInsets.only(top: 14.0),
                  child: Row(
                    children: [
                      Icon(Icons.school_outlined),
                      Expanded(
                          child: Padding(
                        padding: EdgeInsets.only(left: 12.0),
                        child: Container(
                          child: Text(
                            'Кафедра ${disciplineDetails.chair.chairName.toLowerCase()}',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ),
                      ))
                    ],
                  ),
                ),
                SizedBox(
                  height: 7.0,
                ),
                Row(
                  children: [
                    Icon(Icons.account_balance_outlined),
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.only(left: 12.0),
                      child: Container(
                        child: Text(
                          'Факультет ${disciplineDetails.chair.faculty.facName.toLowerCase()}',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ),
                    ))
                  ],
                )
              ],
            ),
          );
        });
  }
}
