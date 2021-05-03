import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SubmitLoaderButton extends StatelessWidget
{
  bool _isLoading;
  String _text;
  Function _onPressed;
  Icon _icon;

  SubmitLoaderButton({@required String text, @required bool isLoading, @required Function onPressed, Icon icon}) {
    this._isLoading = isLoading;
    this._onPressed = onPressed;
    this._text = text;
    this._icon = icon;
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: this._onPressed, 
      child: () {
        if(_isLoading) {
          return Center(child: CircularProgressIndicator());
        } 

        if(_icon != null) {
          return Row(
            children: [
              this._icon,
              Padding(padding: EdgeInsets.only(left: 5.0), child: Text(this._text))
            ],
          );
        }

        return Row(children: [Text(this._text)]);
      }()
    );
  }
}