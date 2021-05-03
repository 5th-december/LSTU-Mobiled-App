import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ModalPage extends StatefulWidget
{
  final String modalTitle;
  final Widget modalContent;
  final BuildContext outerContext;

  ModalPage(this.modalTitle, this.modalContent, {this.outerContext});

  @override
  _ModalPageState createState() => _ModalPageState();
}

class _ModalPageState extends State<ModalPage>
{
  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Container(
          constraints: BoxConstraints(maxHeight: 350.0),
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 12.0),
                  child: Text(widget.modalTitle, style: TextStyle(fontSize: 24)),
                ),
                widget.modalContent
              ],
            )
          )
        )
    );
  }
}