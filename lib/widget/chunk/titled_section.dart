import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TitledSection extends StatelessWidget
{
  final String title;
  final Widget child;

  TitledSection({Key key, @required this.title, @required this.child}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 12.0, right: 12.0, top: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 12.0),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(1, 246, 246, 246),
                    borderRadius: BorderRadius.all(Radius.circular(8.0))
                  ),
                  child: Text(this.title),
                )
              ),
              Padding(padding: EdgeInsets.only(top: 8.0), child: this.child)
            ],
          )
        ],
      ),
    );
  }
}