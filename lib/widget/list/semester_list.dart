import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/bloc/loader/loader_bloc.dart';
import 'package:lk_client/command/consume_command.dart';
import 'package:lk_client/event/consuming_event.dart';
import 'package:lk_client/model/education/education.dart';
import 'package:lk_client/model/education/semester.dart';
import 'package:lk_client/service/api_consumer/education_query_service.dart';
import 'package:lk_client/state/consuming_state.dart';
import 'package:lk_client/store/global/app_state_container.dart';
import 'package:lk_client/widget/layout/rounded_leading_text_image.dart';

class SemesterList extends StatefulWidget {
  final Education _education;
  final Function _onSelectAction;

  SemesterList(this._education, this._onSelectAction);

  @override
  _SemesterListState createState() => _SemesterListState();
}

class _SemesterListState extends State<SemesterList> {
  SemesterListLoadingBloc _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (this._bloc == null) {
      EducationQueryService queryService =
          AppStateContainer.of(context).serviceProvider.educationQueryService;

      this._bloc = SemesterListLoadingBloc(queryService);
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
        StartConsumeEvent<LoadSemsterListCommand>(
            request: LoadSemsterListCommand(widget._education)));

    return StreamBuilder(
        stream: _bloc.consumingStateStream,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data is ConsumingReadyState<List<Semester>>) {
              List<Semester> semestersList =
                  (snapshot.data as ConsumingReadyState<List<Semester>>)
                      .content;

              return Container(
                child: ListView.separated(
                    itemCount: semestersList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        child: ListTile(
                          leading: RoundedLeadingTextImage(
                            phrase:
                                "${semestersList[index].season} ${semestersList[index].year}",
                          ),
                          title: Text(
                              "${semestersList[index].season} ${semestersList[index].year}"),
                          onTap: () {
                            widget._onSelectAction(semestersList[index]);
                          },
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider()),
              );
            }
          }

          return Center(child: CircularProgressIndicator());
        });
  }
}
