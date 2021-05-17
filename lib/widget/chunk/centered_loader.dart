import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CenteredLoader extends StatelessWidget{
  CenteredLoader({Key key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator()
    );
  }
}