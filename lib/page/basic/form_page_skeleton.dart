import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CenteredFormPageSkeleton extends StatefulWidget
{
  final Widget centeredForm;

  CenteredFormPageSkeleton({this.centeredForm});

  @override 
  _CenteredFormPageSkeletonState createState() => _CenteredFormPageSkeletonState();
}

class _CenteredFormPageSkeletonState extends State<CenteredFormPageSkeleton>
{
  Widget get centeredForm => widget.centeredForm;

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.2
            ),
            child: Column(
              children: [
                this.centeredForm
              ],
            ),
          ),
        ],
      )
    );
  }
}