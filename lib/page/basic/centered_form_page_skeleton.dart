import 'package:flutter/widgets.dart';
import 'package:lk_client/page/basic/page_skeleton.dart';

class CenteredFormPageSkeleton extends StatefulWidget
{
  final Widget centeredForm;

  CenteredFormPageSkeleton({this.centeredForm});

  @override 
  _CenteredFormPageSkeletonState createState() => _CenteredFormPageSkeletonState(this.centeredForm);
}

class _CenteredFormPageSkeletonState extends State<CenteredFormPageSkeleton>
{
  Widget _centeredForm;

  _CenteredFormPageSkeletonState(Widget centeredForm) {
    this._centeredForm = centeredForm;
  }

  @override 
  Widget build(BuildContext context) {
    return PageSkeleton(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.2
            ),
            child: Column(
              children: [
                this._centeredForm
              ],
            ),
          ),
        ],
      )
    );
  }
}