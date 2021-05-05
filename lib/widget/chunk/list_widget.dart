import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/state/consuming_state.dart';

class ListWidget<T> extends StatelessWidget
{
  final Function listBuilder;
  final Stream loadingStream;
  Widget loadingPlaceholder;
  Widget errorPlaceholder;

  ListWidget({
    Key key, 
    @required this.loadingStream, 
    @required this.listBuilder, 
    this.loadingPlaceholder, 
    this.errorPlaceholder
  }): super(key: key) {
    if(this.loadingPlaceholder == null) {
      this.loadingPlaceholder = Center(child: CircularProgressIndicator());
    }
    if(this.errorPlaceholder == null) {
      this.errorPlaceholder = Center(child: Text('An unexpected error occurred'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: this.loadingStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final _snapshot = snapshot as AsyncSnapshot<ConsumingState>;
        if(_snapshot.hasData){
          if(_snapshot is ConsumingReadyState) {
            List<T> receivedList = (_snapshot.data as ConsumingReadyState).content;
            return this.listBuilder(receivedList);
          }
        }
        if(snapshot.hasError) {
          return this.errorPlaceholder;
        }
        return this.loadingPlaceholder;
      },
    );
  }
}