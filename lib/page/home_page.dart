import 'package:flutter/material.dart';
import 'package:lk_client/bloc/loader/loader_bloc.dart';
import 'package:lk_client/bloc/navigation_bloc.dart';
import 'package:lk_client/command/consume_command.dart';
import 'package:lk_client/event/consuming_event.dart';
import 'package:lk_client/event/navigation_event.dart';
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/service/api_consumer/person_query_service.dart';
import 'package:lk_client/state/consuming_state.dart';
import 'package:lk_client/store/global/app_state_container.dart';
import 'package:lk_client/store/global/loader_provider.dart';
import 'package:lk_client/store/global/mbc_bloc_provider.dart';
import 'package:lk_client/widget/util/page_global_manager.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserDefinitionLoaderBloc userDefinitionLoaderBloc;
  NavigationBloc navigationBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (this.userDefinitionLoaderBloc == null) {
      PersonQueryService queryService =
          AppStateContainer.of(context).serviceProvider.personQueryService;
      this.userDefinitionLoaderBloc = UserDefinitionLoaderBloc(queryService);
    }

    if (this.navigationBloc == null) {
      this.navigationBloc =
          AppStateContainer.of(context).blocProvider.navigationBloc;
    }
  }

  @override
  dispose() async {
    Future.delayed(Duration.zero, () async {
      await this.userDefinitionLoaderBloc.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    this.userDefinitionLoaderBloc.eventController.sink.add(
        StartConsumeEvent<LoadCurrentUserIdentifier>(
            request: LoadCurrentUserIdentifier()));

    return StreamBuilder(
        stream: this.userDefinitionLoaderBloc.consumingStateStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData &&
              snapshot.data is ConsumingReadyState<Person>) {
            Person person =
                (snapshot.data as ConsumingReadyState<Person>).content;
            if (!this.navigationBloc.eventController.isClosed) {
              this
                  .navigationBloc
                  .eventController
                  .sink
                  .add(NavigateToPageEvent(3));
            }

            return Scaffold(
                body: MbCBlocProvider(
                    child: LoaderProvider(
              child: PageGlobalManager(person),
            )));
          }

          return Center(child: CircularProgressIndicator());
        });
  }
}
