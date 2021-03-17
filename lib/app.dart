import 'package:flutter/material.dart';
import 'page/authorization_page.dart';
import 'page/basic/page_skeleton.dart';
import 'app_theme.dart';
import 'router_path.dart';

class LkApp extends StatefulWidget {
  @override
  _LkAppState createState() => _LkAppState();
}

class _LkAppState extends State<LkApp> {
  final RouteObserver<Route> appRouteObserver = new RouteObserver<Route>();

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LkApp',
      theme: lkAppTheme(),
      routes: {
        RouterPathContainer.appRegisterPage: (context) => RegisterPage(),
        RouterPathContainer.appLoginPage: (context) => LoginPage(),
        RouterPathContainer.appCreateAccount: (context) =>
            PageSkeleton(body: null)
      },
      initialRoute: '/login',
      navigatorObservers: [appRouteObserver],
    );
  }
}
