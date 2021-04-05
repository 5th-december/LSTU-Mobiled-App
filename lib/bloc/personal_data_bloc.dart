import 'dart:async';

import 'package:lk_client/event/content_event.dart';
import 'package:lk_client/event/request_command/user_request_command.dart';
import 'package:lk_client/model/entity/person_entity.dart';
import 'package:lk_client/service/caching/person_query_service.dart';
import 'package:lk_client/state/content_state.dart';

class PersonalDataBloc {
  ContentState _currentContentLoadingState;

  StreamController eventController = StreamController.broadcast();

  // при поступлении команды загрузки объекта пользователя
  Stream<ContentEvent<LoadCurrentUserObject>>
      get _loadCurrentPersonEntityEventStream => eventController.stream.where(
          (event) => event is StartLoadingContentEvent<LoadCurrentUserObject>);

  StreamController _stateController = StreamController.broadcast();

  // отдает состояние с объектом пользователя
  Stream<ContentState<PersonEntity>> get personEntityStateStream =>
      _stateController.stream
          .where((event) => event is ContentState<PersonEntity>);

  void _updateState(ContentState newState) {
    this._currentContentLoadingState = newState;
    this._stateController.sink.add(newState);
  }

  dispose() async {
    await this._stateController.close();
    await this.eventController.close();
  }

  PersonalDataBloc(PersonQueryService personQueryService) {
    // после поступления команды загрузки объекта пользователя
    this._loadCurrentPersonEntityEventStream.listen((event) async {
      this._updateState(ContentLoadingState<PersonEntity>());

      try {
        PersonEntity person = await personQueryService.getCurrentPerson();
      } on Exception catch (ble) {
        this._updateState(ContentErrorState<PersonEntity>(ble));
      }
    });
  }
}
