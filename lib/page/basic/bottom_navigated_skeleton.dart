import 'dart:html';

import 'package:flutter/material.dart';
import 'page_skeleton.dart';

class BottomNavigatedSkeleton extends StatelessWidget
{
  final Widget body;

  BottomNavigationBar bottomNavigationBar;

  Drawer menuDrawer;

  BottomNavigatedSkeleton(this.body) {}

  @override 
  Widget build(BuildContext context)
  {
    return PageSkeleton(
      body: this.body,
      bottomNavigationBar: null,
      menuDrawer: null,
    );
  }
}

