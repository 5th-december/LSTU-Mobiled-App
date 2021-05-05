import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/state/consuming_state.dart';

class StreamLoadingWidget<T> extends StatelessWidget {
  final Function childBuilder;
  final Stream loadingStream;
  Widget loadingPlaceholder;
  Widget errorPlaceholder;

  StreamLoadingWidget(
      {Key key,
      @required this.loadingStream,
      @required this.childBuilder,
      this.loadingPlaceholder,
      this.errorPlaceholder})
      : super(key: key) {
    if (this.loadingPlaceholder == null) {
      this.loadingPlaceholder = Center(child: CircularProgressIndicator());
    }
    if (this.errorPlaceholder == null) {
      this.errorPlaceholder =
          Center(child: Text('An unexpected error occurred'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: this.loadingStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data is ConsumingReadyState) {
            T receivedData =
                (snapshot.data as ConsumingReadyState).content;
            return this.childBuilder(receivedData);
          } else if(snapshot.data is ConsumingErrorState) {
            return this.errorPlaceholder;
          }
        }
        if (snapshot.hasError) {
          return this.errorPlaceholder;
        }
        return this.loadingPlaceholder;
      },
    );
  }
}
