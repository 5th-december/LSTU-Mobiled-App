import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NavigatorWrappedPage extends StatelessWidget {
  final Widget _child;

  NavigatorWrappedPage(this._child);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) {
              return _child;
            });
      },
    );
  }
}
