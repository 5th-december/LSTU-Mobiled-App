import 'package:flutter/material.dart';
import 'package:lk_client/bloc/personal/user_definition_bloc.dart';
import 'package:lk_client/bloc/util/navigation_bloc.dart';
import 'package:lk_client/bloc/personal/personal_details_bloc.dart';
import 'package:lk_client/event/content_event.dart';
import 'package:lk_client/event/navigation_event.dart';
import 'package:lk_client/event/request_command/user_request_command.dart';
import 'package:lk_client/model/education/education.dart';
import 'package:lk_client/model/education/semester.dart';
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/page/basic/navigator_wrapped_page.dart';
import 'package:lk_client/page/education_page.dart';
import 'package:lk_client/page/messenger_page.dart';
import 'package:lk_client/page/personal_page.dart';
import 'package:lk_client/page/semester_page.dart';
import 'package:lk_client/page/subject_list_page.dart';
import 'package:lk_client/page/timetable_page.dart';
import 'package:lk_client/service/api_consumer/person_query_service.dart';
import 'package:lk_client/state/content_state.dart';
import 'package:lk_client/state/navigation_state.dart';
import 'package:lk_client/store/app_state_container.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  NavigationBloc _appNavidationBloc;
  UserDefinitionBloc _personalDataBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (this._appNavidationBloc == null) {
      this._appNavidationBloc =
          AppStateContainer.of(context).blocProvider.navigationBloc;
      PersonQueryService personQueryService =
          AppStateContainer.of(context).serviceProvider.personQueryService;
      this._personalDataBloc = UserDefinitionBloc(personQueryService);
    }
  }

  @override
  dispose() async {
    Future.delayed(Duration.zero, () async {
      await this._appNavidationBloc.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    this._appNavidationBloc.eventController.add(NavigateToEvent(3));

    this._personalDataBloc.eventController.add(
        StartLoadingContentEvent<LoadCurrentUserIdentifier>(
            LoadCurrentUserIdentifier()));

    return Scaffold(
        body: StreamBuilder(
            stream: this._appNavidationBloc.state,
            builder: (BuildContext context,
                AsyncSnapshot<NavigationState> snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                return Scaffold(
                  body: SafeArea(
                      child: IndexedStack(
                          index: () {
                            if (snapshot.hasData) {
                              NavigationState state = snapshot.data;
                              if (state is NavigatedToEducationPage) {
                                return 0;
                              } else if (state is NavigatedToMessagesPage) {
                                return 1;
                              } else if (state is NavigatedToTimetablePage) {
                                return 2;
                              } else if (state is NavigatedToPersonalPage) {
                                return 3;
                              }
                            }
                          }(),
                          children: [
                        StreamBuilder(
                            stream: this
                                ._personalDataBloc
                                .personDefinitionStateSteream,
                            builder: (BuildContext context,
                                AsyncSnapshot<dynamic> snapshot) {
                              if (snapshot.hasData &&
                                  snapshot.data is ContentState<Person>) {
                                Person currentPerson = snapshot.data.content as Person;
                                return NavigatorWrappedPage(
                                  EducationPage(currentPerson, true, (Education edu) {
                                    return SemesterPage(edu, true, (Semester semester) {
                                      return SubjectListPage(edu, semester);
                                    });
                                  })
                                );
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            }),
                        StreamBuilder(
                            stream: this
                                ._personalDataBloc
                                .personDefinitionStateSteream,
                            builder: (BuildContext context,
                                AsyncSnapshot<dynamic> snapshot) {
                              if (snapshot.hasData &&
                                  snapshot.data is ContentState<Person>) {
                                return NavigatorWrappedPage(MessengerPage(
                                    snapshot.data.content as Person));
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            }),
                        StreamBuilder(
                            stream: this
                                ._personalDataBloc
                                .personDefinitionStateSteream,
                            builder: (BuildContext context,
                                AsyncSnapshot<dynamic> snapshot) {
                              if (snapshot.hasData &&
                                  snapshot.data is ContentState<Person>) {
                                return NavigatorWrappedPage(TimetablePage(
                                    snapshot.data.content as Person));
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            }),
                        StreamBuilder(
                            stream: this
                                ._personalDataBloc
                                .personDefinitionStateSteream,
                            builder: (BuildContext context,
                                AsyncSnapshot<dynamic> snapshot) {
                              if (snapshot.hasData &&
                                  snapshot.data is ContentState<Person>) {
                                return NavigatorWrappedPage(PersonalPage(
                                    snapshot.data.content as Person));
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            })
                      ])),
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }),
        bottomNavigationBar: StreamBuilder(
            stream: this._appNavidationBloc.state,
            builder: (BuildContext context,
                AsyncSnapshot<NavigationState> snapshot) {
              return BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  currentIndex:
                      snapshot.data != null ? snapshot.data.selectedIndex : 0,
                  onTap: (index) {
                    this
                        ._appNavidationBloc
                        .eventController
                        .add(NavigateToEvent(index));
                  },
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                        icon:
                            Icon(IconData(62694, fontFamily: 'MaterialIcons')),
                        label: 'Расписание'),
                    BottomNavigationBarItem(
                        icon:
                            Icon(IconData(62489, fontFamily: 'MaterialIcons')),
                        label: 'Образование'),
                    BottomNavigationBarItem(
                        icon:
                            Icon(IconData(61704, fontFamily: 'MaterialIcons')),
                        label: 'Сообщения'),
                    BottomNavigationBarItem(
                        icon:
                            Icon(IconData(58080, fontFamily: 'MaterialIcons')),
                        label: 'Мой профиль')
                  ]);
            }));
  }
}
