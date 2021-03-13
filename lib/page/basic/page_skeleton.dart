import 'package:flutter/material.dart';

class PageSkeleton extends StatelessWidget
{

  Widget body;

  Widget bottomNavigationBar;

  Widget menuDrawer;

  PageSkeleton({
    Key key,
    @required this.body, 
    this.bottomNavigationBar, 
    this.menuDrawer
  }): super(key: key);

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      bottomNavigationBar: this.bottomNavigationBar,
      drawer: this.menuDrawer,
    );
  }
}