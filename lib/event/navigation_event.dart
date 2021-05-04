import 'package:flutter/widgets.dart';

abstract class NavigationEvent {
  final int pageNumber;
  NavigationEvent(this.pageNumber);
}

class NavigateToPageEvent extends NavigationEvent {
  NavigateToPageEvent(pageNumber) : super(pageNumber);
}

class NavigateToCustomPageEvent extends NavigationEvent {
  final Widget customPage;
  NavigateToCustomPageEvent(int pageNumber, this.customPage)
      : super(pageNumber);
}
