import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FullscreenErrorPage extends StatelessWidget {
  final String errorText;
  final Function() onReloadClick;

  FullscreenErrorPage(this.errorText, [this.onReloadClick]);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(this.errorText),
          Visibility(
            visible: this.onReloadClick != null,
            child: ElevatedButton(
              onPressed: this.onReloadClick, 
              child: Text('Обновить')
            )
          )
        ],
      ),
    );
  }
}