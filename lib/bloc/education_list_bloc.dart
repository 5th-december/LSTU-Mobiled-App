import 'dart:async';

import 'package:lk_client/event/content_event.dart';
import 'package:lk_client/model/entity/education_entity.dart';
import 'package:lk_client/state/content_state.dart';

class EducationListBloc
{
  ContentState<EducationEntity> _currentState;

  StreamController<ContentState<EducationEntity>> _stateController = StreamController<ContentState<EducationEntity>>.broadcast();
  Stream<ContentState<EducationEntity>> get state => _stateController.stream;

  StreamController<ContentEvent> _eventController = StreamController<ContentEvent>.broadcast();
  Stream<ContentEvent> get _loadStateEvent => _eventController.stream.where((event) => event is StartLoadingContentEvent);

  void _updateState(ContentState<EducationEntity> state)
  {
    this._currentState = state;
    this._stateController.add(state);
  }

  dispose() async {
    await this._stateController.close();
    await this._eventController.close();
  }

  EducationListBloc()
  {
    this._loadStateEvent.listen((event) {
      this._updateState(ContentLoadingState());

      
    });
  }
  
}