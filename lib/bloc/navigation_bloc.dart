import 'dart:async';

import 'package:lk_client/bloc/abstract_bloc.dart';
import 'package:lk_client/event/navigation_event.dart';
import 'package:lk_client/state/navigation_state.dart';

class NavigationBloc extends AbstractBloc<NavigationState, NavigationEvent> {
  Stream<NavigationState> get navigationStateStream =>
      this.stateContoller.stream;

  Stream<NavigationEvent> get _navigationEventStream => this
      .eventController
      .stream
      .where((event) => event is NavigateToPageEvent);

  Stream<NavigationEvent> get _navigateToCustomPageEventStream => this
      .eventController
      .stream
      .where((event) => event is NavigateToCustomPageEvent);

  NavigationBloc() {
    this._navigationEventStream.listen((NavigationEvent event) {
      final _event = event as NavigateToPageEvent;
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
          return;
      }
    });

    this._navigateToCustomPageEventStream.listen((event) {});
  }
}
