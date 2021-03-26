abstract class NavigationEvent {}

class NavigateToEvent extends NavigationEvent {
  final int pageNumber;
  NavigateToEvent(this.pageNumber);
}