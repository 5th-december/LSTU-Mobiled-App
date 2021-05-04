import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/bloc/navigation_bloc.dart';
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
import 'package:lk_client/state/navigation_state.dart';
import 'package:lk_client/store/global/app_state_container.dart';
import 'package:lk_client/store/local/timetable_page_state_container.dart';

class PageGlobalManager extends StatefulWidget {
  final Person loggedPerson;

  PageGlobalManager(this.loggedPerson);

  @override
  _PageGlobalManagerState createState() => _PageGlobalManagerState();
}

class _PageGlobalManagerState extends State<PageGlobalManager> {
  NavigationBloc _navigator;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (this._navigator == null) {
      this._navigator =
          AppStateContainer.of(context).blocProvider.navigationBloc;
    }
  }

  @override
  dispose() async {
    Future.delayed(Duration.zero, () async {
      await this._navigator.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: this._navigator.navigationStateStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            NavigationState event = snapshot.data as NavigationState;

            return IndexedStack(
              index: event.selectedIndex,
              children: [
                NavigatorWrappedPage(
                  TimetablePageStateContainer(
                    child: TimetablePage(widget.loggedPerson),
                    global: AppStateContainer.of(context)
                  )
                ),
                NavigatorWrappedPage(
                    EducationPage(
                        widget.loggedPerson,
                        (Education edu) => SemesterPage(
                            edu,
                            (Semester semester) =>
                                SubjectListPage(edu, semester)))),
                NavigatorWrappedPage(MessengerPage(widget.loggedPerson)),
                NavigatorWrappedPage(PersonalPage(widget.loggedPerson))
              ],
            );
          }

          return Center(child: CircularProgressIndicator());
        });
  }
}
