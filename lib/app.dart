import 'package:flutter/material.dart';
import 'page/authorization_page.dart';
import 'page/basic/page_skeleton.dart';

class LkApp extends StatelessWidget
{
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LkApp',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: 'Raleway'
      ),
      routes: {
        '/register': (context) => RegisterPage(),
        '/login': (context) => LoginPage(),
        '/create-account': (context) => PageSkeleton(body: null)
      },
      initialRoute: '/login',
    );
  }
}
