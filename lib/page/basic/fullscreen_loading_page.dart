import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FullscreenLoadingPage extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Загрузка...'),
      ),
      body: Center(
        child: CircularProgressIndicator(),
      )
    );
  }
}