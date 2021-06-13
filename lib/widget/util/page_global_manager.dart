import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/bloc/navigation_bloc.dart';
import 'package:lk_client/event/navigation_event.dart';
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/page/basic/navigator_wrapped_page.dart';
import 'package:lk_client/page/messenger_page.dart';
import 'package:lk_client/page/personal_page.dart';
import 'package:lk_client/state/navigation_state.dart';
import 'package:lk_client/store/global/app_state_container.dart';
import 'package:lk_client/store/local/messenger_page_provider.dart';
import 'package:lk_client/store/local/page_index_provider.dart';
import 'package:lk_client/store/local/profile_page_provider.dart';
import 'package:lk_client/store/local/subject_page_provider.dart';
import 'package:lk_client/store/local/timetable_page_provider.dart';
import 'package:lk_client/widget/util/subject_page_manager.dart';
import 'package:lk_client/widget/util/timetable_page_manager.dart';

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
    // TODO: Обработка NavigatedToCustomPage
    this._navigator.eventController.sink.add(NavigateToPageEvent(3));

    return StreamBuilder(
        stream: this._navigator.navigationStateStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            NavigationState event = snapshot.data as NavigationState;

            return IndexedStack(
              index: event.selectedIndex,
              children: [
                PageIndexProvider(
                    pageIndex: 0,
                    child: TimetablePageProvider(
                        child: NavigatorWrappedPage(
                            TimetablePageManager(widget.loggedPerson)))),
                PageIndexProvider(
                    pageIndex: 1,
                    child: SubjectPageProvider(
                        child: NavigatorWrappedPage(SubjectPageManager(
                            currentPerson: widget.loggedPerson)))),
                PageIndexProvider(
                    pageIndex: 2,
                    child: MessengerPageProvider(
                        child: NavigatorWrappedPage(
                            MessengerPage(widget.loggedPerson)))),
                PageIndexProvider(
                    pageIndex: 3,
                    child: ProfilePageProvider(
                        child: NavigatorWrappedPage(
                            PersonalPage(widget.loggedPerson))))
              ],
            );
          }

          return Center(child: CircularProgressIndicator());
        });
  }
}
