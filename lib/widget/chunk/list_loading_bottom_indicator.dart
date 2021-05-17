
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ListLoadingBottomIndicator extends StatelessWidget
{
  ListLoadingBottomIndicator({Key key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5.0),
          child: CircularProgressIndicator(),
        )
      ]
    );
  }
}