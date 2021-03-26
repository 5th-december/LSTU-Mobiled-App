import 'package:flutter/material.dart';
import 'package:lk_client/page/basic/private_page_skeleton.dart';
import 'package:lk_client/page/home_page.dart';
import 'package:lk_client/service/http/authorization_service.dart';
import 'app_theme.dart';
import 'router_path.dart';

class LkApp extends StatefulWidget {
  AuthorizationService appAuthorizationService;

  LkApp(this.appAuthorizationService);

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
        RouterPathContainer.appHomePage: (context) => PrivatePageSkeleton(HomePage())
      },
      initialRoute: RouterPathContainer.appHomePage,
      navigatorObservers: [appRouteObserver],
    );
  }
}
