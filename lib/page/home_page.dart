import 'package:flutter/material.dart';
import 'package:lk_client/bloc/navigation_bloc.dart';
import 'package:lk_client/event/navigation_event.dart';
import 'package:lk_client/page/education_page.dart';
import 'package:lk_client/page/messenger_page.dart';
import 'package:lk_client/page/personal_page.dart';
import 'package:lk_client/page/timetable_page.dart';
import 'package:lk_client/state/navigation_state.dart';
import 'package:lk_client/store/app_state_container.dart';

class HomePage extends StatefulWidget
{
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
{
  NavigationBloc _appNavidationBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (this._appNavidationBloc == null) {
      this._appNavidationBloc = AppStateContainer.of(context).blocProvider.navigationBloc;
    }
  }

  @override
  dispose() async {
    Future.delayed(Duration.zero, () async{
      await this._appNavidationBloc.dispose();
    });
    super.dispose();
  }

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: this._appNavidationBloc.state,
        builder: (BuildContext context, AsyncSnapshot<NavigationState> snapshot) {
          if(snapshot.connectionState == ConnectionState.active) {
            NavigationState receivedState = snapshot.data;
            if (receivedState is NavigatedToEducationPage) {
              return EducationPage();
            } else if (receivedState is NavigatedToMessagesPage) {
              return MessengerPage();
            } else if (receivedState is NavigatedToTimetablePage) {
              return TimetablePage();
            } else if (receivedState is NavigatedToPersonalPage) {
              return PersonalPage();
            }
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      ),
      bottomNavigationBar: StreamBuilder(
        stream: this._appNavidationBloc.state,
        builder: (BuildContext context, AsyncSnapshot<NavigationState> snapshot) {
          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: snapshot.data != null ? snapshot.data.selectedIndex : 0,
            onTap: (index) {
              this._appNavidationBloc.eventController.add(NavigateToEvent(index));
            },
            items: const <BottomNavigationBarItem> [
              BottomNavigationBarItem(
                icon: Icon(IconData(62694, fontFamily: 'MaterialIcons')),
                label: 'Расписание' 
              ),
              BottomNavigationBarItem(
                icon: Icon(IconData(62489, fontFamily: 'MaterialIcons')),
                label: 'Образование'
              ),
              BottomNavigationBarItem(
                icon: Icon(IconData(61704, fontFamily: 'MaterialIcons')),
                label: 'Сообщения'
              ),
              BottomNavigationBarItem(
                icon: Icon(IconData(58080, fontFamily: 'MaterialIcons')),
                label: 'Мой профиль'
              )
            ]
          );
        }
      )
    );
  }
}