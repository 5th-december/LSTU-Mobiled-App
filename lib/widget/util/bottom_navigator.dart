import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/bloc/navigation_bloc.dart';
import 'package:lk_client/event/navigation_event.dart';
import 'package:lk_client/state/navigation_state.dart';
import 'package:lk_client/store/global/app_state_container.dart';

class BottomNavigator extends StatefulWidget {
  final int startIndex;

  BottomNavigator({this.startIndex});

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
    this._navigator.eventController.add(NavigateToPageEvent(widget.startIndex));

    return StreamBuilder(
        stream: this._navigator.navigationStateStream,
        builder:
            (BuildContext context, AsyncSnapshot<NavigationState> snapshot) {
          return BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex:
                  snapshot.data != null ? snapshot.data.selectedIndex : 0,
              onTap: (index) {
                this._navigator.eventController.add(NavigateToPageEvent(index));
              },
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: Icon(IconData(62694, fontFamily: 'MaterialIcons')),
                    label: 'Расписание'),
                BottomNavigationBarItem(
                    icon: Icon(IconData(62489, fontFamily: 'MaterialIcons')),
                    label: 'Образование'),
                BottomNavigationBarItem(
                    icon: Icon(IconData(61704, fontFamily: 'MaterialIcons')),
                    label: 'Сообщения'),
                BottomNavigationBarItem(
                    icon: Icon(IconData(58080, fontFamily: 'MaterialIcons')),
                    label: 'Мой профиль')
              ]);
        });
  }
}
