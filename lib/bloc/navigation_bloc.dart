import 'dart:async';

import 'package:lk_client/event/navigation_event.dart';
import 'package:lk_client/state/navigation_state.dart';

class NavigationBloc
{
  StreamController<NavigationState> _stateContoller = StreamController<NavigationState>.broadcast();
  Stream<NavigationState> get state => _stateContoller.stream;

  StreamController<NavigationEvent> eventController = StreamController<NavigationEvent>();
  Stream<NavigationEvent> get _navigatedEvent => eventController.stream.where((event) => event is NavigateToEvent);

  NavigationState _currentNavigationState;

  void _updateState(NavigationState newState) {
    this._currentNavigationState = newState;
    this._stateContoller.sink.add(newState);
  }

  dispose() async {
    await this._stateContoller.close();
    await this.eventController.close();
  }

  NavigationBloc() {    
    this._navigatedEvent.listen((NavigationEvent event) {
      NavigateToEvent _event = event as NavigateToEvent;
      switch(_event.pageNumber) {
        case 0:
          this._updateState(NavigatedToTimetablePage(_event.pageNumber));
          break;
        case 1: 
          this._updateState(NavigatedToEducationPage(_event.pageNumber));
          break;
        case 2:
          this._updateState(NavigatedToMessagesPage(_event.pageNumber));
          break;
        case 3:
          this._updateState(NavigatedToPersonalPage(_event.pageNumber));
          break;
        default:
          this._updateState(NavigatedToPersonalPage(_event.pageNumber));
      }
    });
  }
}