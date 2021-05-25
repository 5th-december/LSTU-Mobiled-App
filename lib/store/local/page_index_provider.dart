import 'package:flutter/widgets.dart';

class PageIndexProvider extends StatefulWidget {
  final Widget child;
  final int pageIndex;

  PageIndexProvider({Key key, @required this.child, @required this.pageIndex})
      : super(key: key);

  State<PageIndexProvider> createState() => PageIndexProviderState();

  static PageIndexProviderState of(BuildContext context) {
    PageIndexProviderInherited inherited = context
        .dependOnInheritedWidgetOfExactType<PageIndexProviderInherited>();
    return inherited.pageIndexState;
  }
}

class PageIndexProviderInherited extends InheritedWidget {
  final PageIndexProviderState pageIndexState;

  PageIndexProviderInherited(
      {Key key, @required this.pageIndexState, @required child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(PageIndexProviderInherited old) =>
      this.pageIndexState != old.pageIndexState;
}

class PageIndexProviderState extends State<PageIndexProvider> {
  int get pageIndex => widget.pageIndex;

  @override
  Widget build(BuildContext context) {
    return PageIndexProviderInherited(
        child: widget.child, pageIndexState: this);
  }
}
