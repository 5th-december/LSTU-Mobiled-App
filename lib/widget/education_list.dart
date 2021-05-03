import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lk_client/bloc/education/education_list_bloc.dart';
import 'package:lk_client/event/content_event.dart';
import 'package:lk_client/event/request_command/education_request_command.dart';
import 'package:lk_client/model/education/education.dart';
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/service/api_consumer/education_query_service.dart';
import 'package:lk_client/state/content_list_state.dart';
import 'package:lk_client/state/content_state.dart';
import 'package:lk_client/store/app_state_container.dart';

class EducationList extends StatefulWidget {
  final Person _currentPerson;
  final bool allowToSelectByDefault;
  final Function navigateToNextPage;

  EducationList(this._currentPerson, this.allowToSelectByDefault, this.navigateToNextPage);

  @override
  _EducationListState createState() => _EducationListState();
}

class _EducationListState extends State<EducationList> {
  EducationListBloc _educationBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (this._educationBloc == null) {
      EducationQueryService queryService =
          AppStateContainer.of(context).serviceProvider.educationQueryService;
      this._educationBloc = EducationListBloc(queryService, widget.allowToSelectByDefault);
    }
  }

  @override
  dispose() async {
    Future.delayed(Duration.zero, () async {
      await this._educationBloc.dispose();
    });
    super.dispose();
  }

  Widget build(BuildContext context) {
    this._educationBloc.eventController.sink.add(
        StartLoadingContentEvent<LoadUserEducationListCommand>(
            LoadUserEducationListCommand(widget._currentPerson)));

    return StreamBuilder(
      stream: this._educationBloc.educationListStateStream,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          if(snapshot.data is ContentReadyState<List<Education>>) {
            List<Education> educationsList =
                (snapshot.data as ContentReadyState<List<Education>>)
                  .content;

            return Container(
              child: ListView.builder(
                itemCount: educationsList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: ListTile(
                        leading: FlutterLogo(
                          size: 50,
                        ),
                        title: Text(educationsList[index].group.speciality.specName),
                        subtitle: Text(educationsList[index].group.speciality.qualification),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) {
                              return widget.navigateToNextPage(educationsList[index]);
                            })
                          );
                        },
                      ),
                    );
                  }
              )
            );
          } else if (snapshot.data is SelectSingleDefaultFromList<Education>) {
            Education selectedEducation = (snapshot.data as SelectSingleDefaultFromList<Education>).selected;

            Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) {
                return widget.navigateToNextPage(selectedEducation);
              })
            );
          }
        }
        
        return Center(
          child: CircularProgressIndicator(),
        );

      }
    );
  }
}
