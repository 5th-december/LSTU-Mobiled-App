import 'package:flutter/material.dart';
import 'package:lk_client/store/global/service_provider.dart';
import '../global/bloc_provider.dart';

class AppStateContainer extends StatefulWidget {
  final Widget child;
  final BlocProvider blocProvider;
  final ServiceProvider serviceProvider;

  AppStateContainer(
      {Key key,
      @required this.child,
      @required this.blocProvider,
      @required this.serviceProvider})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => AppState();

  static AppState of(BuildContext context) {
    AppStateContainerInherited inherited = context
        .dependOnInheritedWidgetOfExactType<AppStateContainerInherited>();
    return inherited.appState;
  }
}

class AppStateContainerInherited extends InheritedWidget {
  final AppState appState;

  AppStateContainerInherited(
      {Key key, @required this.appState, @required child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(AppStateContainerInherited old) => true;
}

class AppState extends State<AppStateContainer> {
  BlocProvider get blocProvider => widget.blocProvider;
  ServiceProvider get serviceProvider => widget.serviceProvider;

  @override
  Widget build(BuildContext context) {
    return AppStateContainerInherited(
      appState: this,
      child: widget.child,
    );
  }
}
