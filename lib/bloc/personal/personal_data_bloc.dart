import 'dart:async';

import 'package:lk_client/bloc/abstract_bloc.dart';
import 'package:lk_client/event/content_event.dart';
import 'package:lk_client/event/request_command/user_request_command.dart';
import 'package:lk_client/model/entity/person_entity.dart';
import 'package:lk_client/service/caching/person_query_service.dart';
import 'package:lk_client/state/content_state.dart';

class PersonalDataBloc extends AbstractBloc<ContentState, ContentEvent> {
  Stream<ContentEvent> get _loadCurrentPersonEntityEventStream => this
      .eventController
      .stream
      .where((event) =>
              event is StartLoadingContentEvent<LoadCurrentUserObject>);

  Stream<ContentState> get personEntityStateStream => this
      .stateContoller
      .stream
      .where((event) => event is ContentState<PersonEntity>);

  PersonalDataBloc(PersonQueryService personQueryService) {
    
    this._loadCurrentPersonEntityEventStream.listen((ContentEvent event) async {
      this.updateState(ContentLoadingState<PersonEntity>());

      try {
        PersonEntity person = await personQueryService.getCurrentPerson();
        this.updateState(ContentReadyState<PersonEntity>(person));
      } on Exception catch (ble) {
        this.updateState(ContentErrorState<PersonEntity>(ble));
      }
    });
  }
}
