import 'package:flutter/material.dart';
import 'bloc_container.dart';

class AppStateContainer extends StatefulWidget
{
  final Widget childWidget;
  final BlocContainer blocContainer;

  AppStateContainer({
    Key key,
    this.childWidget,
    this.blocContainer
  }): super(key: key);

  @override 
  State<StatefulWidget> createState() => AppState();

  static AppState of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<AppStateContainerInherited>(aspect: AppStateContainerInherited)).appState;
  }
}

class AppStateContainerInherited extends InheritedWidget
{
  final AppState appState;
  final BlocContainer blocContainer;
  final Widget child;

  AppStateContainerInherited({
    Key key,
    this.appState,
    this.blocContainer,
    this.child
  }): super(key: key, child: child);

  @override 
  bool updateShouldNotify(AppStateContainerInherited old) => old.appState != this.appState;
}

class AppState extends State<AppStateContainer>
{
  BlocContainer get blockContainer => widget.blocContainer;

  // global defined values here
  // bloc container access by AppStateContainer.of(context).blockContainer

  @override
  Widget build(BuildContext context) {
    return AppStateContainerInherited(
      appState: this,
      blocContainer: widget.blocContainer,
      child: widget.childWidget,
    );
  }
}