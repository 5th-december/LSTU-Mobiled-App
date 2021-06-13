import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/bloc/widget/messenger_tile_unread_bloc.dart';
import 'package:lk_client/state/consuming_state.dart';

class MessengerTileUnreadWidget extends StatefulWidget {
  final MessengerTileUnreadBloc bloc;

  MessengerTileUnreadWidget({@required this.bloc});

  @override
  State<MessengerTileUnreadWidget> createState() =>
      _MessengerTileUnreadWidgetState();
}

class _MessengerTileUnreadWidgetState extends State<MessengerTileUnreadWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget.bloc.messengerUnreadCountStateStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data is ConsumingReadyState<int>) {
              int value = (snapshot.data as ConsumingReadyState<int>).content;
              return Container(
                padding: EdgeInsets.all(4),
                decoration: new BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(9),
                ),
                constraints: BoxConstraints(
                  minWidth: 18,
                  minHeight: 18,
                ),
                child: new Text(
                  '$value',
                  style: new TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }
          }

          return SizedBox.shrink();
        });
  }
}
