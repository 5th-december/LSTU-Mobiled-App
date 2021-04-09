import 'dart:async';

import 'package:lk_client/bloc/abstract_bloc.dart';
import 'package:lk_client/event/navigation_event.dart';
import 'package:lk_client/state/navigation_state.dart';

class NavigationBloc extends AbstractBloc<NavigationState, NavigationEvent> {
  Stream<NavigationState> get state => this.stateContoller.stream;

  Stream<NavigationEvent> get _navigatedEvent =>
      this.eventController.stream.where((event) => event is NavigateToEvent);

  NavigationBloc() {
    this._navigatedEvent.listen((NavigationEvent event) {
      NavigateToEvent _event = event as NavigateToEvent;
      switch (_event.pageNumber) {
        case 0:
          this.updateState(NavigatedToTimetablePage(_event.pageNumber));
          break;
        case 1:
          this.updateState(NavigatedToEducationPage(_event.pageNumber));
          break;
        case 2:
          this.updateState(NavigatedToMessagesPage(_event.pageNumber));
          break;
        case 3:
          this.updateState(NavigatedToPersonalPage(_event.pageNumber));
          break;
        default:
          this.updateState(NavigatedToPersonalPage(_event.pageNumber));
      }
    });
  }
}
