import 'package:flutter/material.dart';
import 'package:lk_client/page/authorization_pages.dart';
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
        RouterPathContainer.appAuthorizePage: (context) => LoginPage(),
        RouterPathContainer.appIdentifyPage: (context) => IdentificationPage(),
        RouterPathContainer.appHomePage: (context) => PageSkeleton(body: null)
      },
      initialRoute: RouterPathContainer.appAuthorizePage,
      navigatorObservers: [appRouteObserver],
    );
  }
}
