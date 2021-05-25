import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/bloc/navigation_bloc.dart';
import 'package:lk_client/event/navigation_event.dart';
import 'package:lk_client/store/global/app_state_container.dart';
import 'package:lk_client/store/local/page_index_provider.dart';

class BottomNavigator extends StatefulWidget {
  @override
  _BottomNavigatorState createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
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
  Widget build(BuildContext context) {
    int selectedIndex = PageIndexProvider.of(context)?.pageIndex ?? 0;

    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        onTap: (index) {
          this._navigator.eventController.add(NavigateToPageEvent(index));
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_rounded), label: 'Расписание'),
          BottomNavigationBarItem(
              icon: Icon(Icons.school_rounded), label: 'Образование'),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_rounded), label: 'Сообщения'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_rounded), label: 'Мой профиль')
        ]);
  }
}
