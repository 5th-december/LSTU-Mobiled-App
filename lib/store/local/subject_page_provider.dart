import 'package:flutter/widgets.dart';

class SubjectPageProvider extends StatefulWidget {
  final Widget child;

  SubjectPageProvider({Key key, @required this.child}) : super(key: key);

  @override
  SubjectPageProviderState createState() => SubjectPageProviderState();

  static SubjectPageProviderState of(BuildContext context) {
    SubjectPageInherited inherited =
        context.dependOnInheritedWidgetOfExactType<SubjectPageInherited>();
    return inherited.pageState;
  }
}

class SubjectPageInherited extends InheritedWidget {
  final SubjectPageProviderState pageState;

  SubjectPageInherited({Key key, @required this.pageState, @required child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(SubjectPageInherited old) =>
      this.pageState != old.pageState;
}

class SubjectPageProviderState extends State<SubjectPageProvider> {
  @override
  Widget build(BuildContext context) {
    return SubjectPageInherited(pageState: this, child: widget.child);
  }
}
