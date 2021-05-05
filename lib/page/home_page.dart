import 'package:flutter/material.dart';
import 'package:lk_client/bloc/loader_bloc.dart';
import 'package:lk_client/bloc/navigation_bloc.dart';
import 'package:lk_client/command/consume_command/user_request_command.dart';
import 'package:lk_client/event/consuming_event.dart';
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/service/api_consumer/person_query_service.dart';
import 'package:lk_client/state/consuming_state.dart';
import 'package:lk_client/store/global/app_state_container.dart';
import 'package:lk_client/widget/util/bottom_navigator.dart';
import 'package:lk_client/widget/util/page_global_manager.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserDefinitionLoaderBloc _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (this._bloc == null) {
      PersonQueryService queryService =
          AppStateContainer.of(context).serviceProvider.personQueryService;
      this._bloc = UserDefinitionLoaderBloc(queryService);
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
        StartConsumeEvent<LoadCurrentUserIdentifier>(request:
            LoadCurrentUserIdentifier()));

    return StreamBuilder(
        stream: this._bloc.consumingStateStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
      if (snapshot.hasData && snapshot.data is ConsumingReadyState<Person>) {
        Person person = (snapshot.data as ConsumingReadyState<Person>).content;

        return Scaffold(
            body: PageGlobalManager(person),
            bottomNavigationBar: BottomNavigator(startIndex: 3));
      }

      return Center(child: CircularProgressIndicator());
    });
  }
}
