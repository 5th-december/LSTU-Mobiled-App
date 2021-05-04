import 'package:flutter/material.dart';
import 'package:lk_client/bloc/navigation_bloc.dart';
import 'package:lk_client/bloc/user_definition_bloc.dart';
import 'package:lk_client/command/consume_command/user_request_command.dart';
import 'package:lk_client/event/content_event.dart';
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/service/api_consumer/person_query_service.dart';
import 'package:lk_client/state/content_state.dart';
import 'package:lk_client/store/global/app_state_container.dart';
import 'package:lk_client/widget/util/bottom_navigator.dart';
import 'package:lk_client/widget/util/page_global_manager.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserDefinitionBloc _userDefinitionBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (this._userDefinitionBloc == null) {
      PersonQueryService queryService =
          AppStateContainer.of(context).serviceProvider.personQueryService;
      this._userDefinitionBloc = UserDefinitionBloc(queryService);
    }
  }

  @override
  dispose() async {
    Future.delayed(Duration.zero, () async {
      await this._userDefinitionBloc.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    this._userDefinitionBloc.eventController.sink.add(
        StartLoadingContentEvent<LoadCurrentUserIdentifier>(
            LoadCurrentUserIdentifier()));

    return StreamBuilder(
        stream: this._userDefinitionBloc.personDefinitionStateSteream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
      if (snapshot.hasData && snapshot.data is ContentReadyState<Person>) {
        Person person = (snapshot.data as ContentReadyState<Person>).content;

        return Scaffold(
            body: PageGlobalManager(person),
            bottomNavigationBar: BottomNavigator(startIndex: 3));
      }

      return Center(child: CircularProgressIndicator());
    });
  }
}
