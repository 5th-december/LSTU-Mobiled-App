import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WaitModalWidget extends StatelessWidget {
  final String text;

  WaitModalWidget({Key key, this.text = 'Загрузка'});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 12.0),
              Text(this.text),
            ],
          )),
    );
  }
}
