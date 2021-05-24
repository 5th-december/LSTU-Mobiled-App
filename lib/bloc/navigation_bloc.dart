import 'dart:async';

import 'package:lk_client/bloc/abstract_bloc.dart';
import 'package:lk_client/event/navigation_event.dart';
import 'package:lk_client/state/navigation_state.dart';

class NavigationBloc extends AbstractBloc<NavigationState, NavigationEvent> {
  Stream<NavigationState> get navigationStateStream =>
      this.stateContoller.stream;

  /*
   * Переход на указанную вкладку
   * Событие игнорируется если требуемая вкладка уже открыта
   */
  Stream<NavigationEvent> get _navigationEventStream =>
      this.eventController.stream.where((event) =>
          event is NavigateToPageEvent &&
          event.pageNumber != currentState?.selectedIndex);

  /*
   * Открытие страницы в указанной вкладке
   */
  Stream<NavigationEvent> get _navigateToCustomPageEventStream =>
      this.eventController.stream.where((event) =>
          event is NavigateToCustomPageEvent &&
          event.pageNumber != currentState.selectedIndex);

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

    this._navigateToCustomPageEventStream.listen((event) {
      /**
       * Для открытия произвольной страницы в указанной вкладке
       * В page managere нужно обрабатывать такие события, push на навигаторах с указанными индексами
       */
    });
  }
}
