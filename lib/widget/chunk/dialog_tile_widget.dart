import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/bloc/widget/messenger_tile_bloc.dart';
import 'package:lk_client/bloc/widget/messenger_tile_unread_bloc.dart';
import 'package:lk_client/bloc_container/mbc_private_message_bloc_container.dart';
import 'package:lk_client/event/consuming_event.dart';
import 'package:lk_client/model/messenger/dialog.dart' as Dl;
import 'package:lk_client/model/messenger/private_message.dart';
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/state/consuming_state.dart';
import 'package:lk_client/store/global/mbc_bloc_provider.dart';
import 'package:lk_client/widget/chunk/messenger_tile_unread_widget.dart';
import 'package:lk_client/widget/layout/profile_picture.dart';

class DialogTileWidget extends StatefulWidget {
  final Dl.Dialog dialog;
  final Person person;
  final PrivateMessage lastloadedMessage;

  final Future<MessengerTileBloc> messengerTileBloc;

  DialogTileWidget(
      {@required this.dialog,
      this.lastloadedMessage,
      @required this.person,
      @required this.messengerTileBloc});

  @override
  State<StatefulWidget> createState() =>
      _DialogTileWidgetState(this.messengerTileBloc);
}

class _DialogTileWidgetState extends State<DialogTileWidget> {
  final Future<MessengerTileBloc> _messengerTileBloc;

  _DialogTileWidgetState(this._messengerTileBloc);

  Future<MbCPrivateMessageBlocContainer> _privateMessageBlocContainer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (this._privateMessageBlocContainer == null) {
      this._privateMessageBlocContainer =
          MbCBlocProvider.of(context).mbCPrivateMessageBlocContainer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              PersonProfilePicture(displayed: widget.person, size: 34.0)
            ],
          ),
          SizedBox(width: 12.0),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                      child: Text(
                    '${widget.person?.name ?? ''} ${widget.person?.surname ?? ''}',
                    style: Theme.of(context).textTheme.headline5,
                  ))
                ],
              ),
              SizedBox(
                height: 8.0,
              ),
              Row(
                children: [
                  Expanded(
                      child: FutureBuilder(
                    future: this._messengerTileBloc,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.done:
                          if (snapshot.hasData) {
                            MessengerTileBloc bloc = snapshot.data;
                            bloc.eventController.sink.add(
                                StartConsumeEvent<Dl.Dialog>(
                                    request: widget.dialog));
                            return StreamBuilder(
                                stream: bloc.messageUpdateStateStream,
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.hasData) {
                                    ConsumingState<PrivateMessage> state =
                                        snapshot.data;
                                    if (state is ConsumingReadyState<
                                        PrivateMessage>) {
                                      final lastMessage = state.content;
                                      return Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 8.0),
                                        decoration: BoxDecoration(
                                            color:
                                                (lastMessage?.isRead ?? false)
                                                    ? Colors.transparent
                                                    : Color.fromRGBO(
                                                        243, 243, 243, 1.0),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8.0))),
                                        child: Row(
                                          children: [
                                            Expanded(child: () {
                                              String lastMessageString = '';
                                              if (lastMessage?.meSender ??
                                                  false) {
                                                lastMessageString += 'Вы: ';
                                              } else {
                                                lastMessageString +=
                                                    '${lastMessage.sender?.name ?? ''} ${lastMessage.sender?.surname ?? ''}: ';
                                              }
                                              lastMessageString +=
                                                  lastMessage.messageText;
                                              return Text(
                                                lastMessageString,
                                                maxLines: 1,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1,
                                              );
                                            }()),
                                            () {
                                              String sendLabel = '';
                                              final currentDateTime =
                                                  DateTime.now();
                                              final lastMessageSentTime =
                                                  lastMessage?.sendTime;
                                              if (lastMessageSentTime == null) {
                                                return Text('');
                                              }
                                              if (lastMessageSentTime.year ==
                                                  currentDateTime.year) {
                                                if (lastMessageSentTime.month ==
                                                    currentDateTime.month) {
                                                  if (lastMessageSentTime.day +
                                                          1 ==
                                                      currentDateTime.day) {
                                                    sendLabel = 'вчера';
                                                  } else if (lastMessageSentTime
                                                          .day ==
                                                      currentDateTime.day) {
                                                    sendLabel =
                                                        '${lastMessageSentTime.hour.toString().padLeft(2, '0')}:${lastMessageSentTime.minute.toString().padLeft(2, '0')}';
                                                  } else {
                                                    sendLabel =
                                                        '${lastMessageSentTime.day.toString().padLeft(2, '0')}.${lastMessageSentTime.month.toString().padLeft(2, '0')}';
                                                  }
                                                } else {
                                                  sendLabel =
                                                      '${lastMessageSentTime.day.toString().padLeft(2, '0')}.${lastMessageSentTime.month.toString().padLeft(2, '0')}';
                                                }
                                              } else {
                                                sendLabel =
                                                    '${lastMessageSentTime.month.toString().padLeft(2, '0')}.${lastMessageSentTime.year}';
                                              }

                                              return Text(sendLabel,
                                                  maxLines: 1,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1);
                                            }(),
                                          ],
                                        ),
                                      );
                                    } else {
                                      return SizedBox.shrink();
                                    }
                                  }

                                  return SizedBox.shrink();
                                });
                          }

                          return SizedBox.shrink();
                          break;
                        default:
                          return SizedBox.shrink();
                      }
                    },
                  ))
                ],
              )
            ],
          )),
          /*Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FutureBuilder(
                future: MessengerTileUnreadBloc.init(
                    privateMessageBlocContainer:
                        this._privateMessageBlocContainer,
                    dialog: widget.dialog,
                    person: widget.person),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.done:
                      final MessengerTileUnreadBloc messengerTileUnreadBloc =
                          snapshot.data;
                      messengerTileUnreadBloc.eventController.sink.add(
                          StartConsumeEvent<Dl.Dialog>(request: widget.dialog));
                      return MessengerTileUnreadWidget(
                        bloc: messengerTileUnreadBloc,
                      );
                      break;
                    default:
                      return SizedBox.shrink();
                  }
                },
              )
            ],
          )*/
        ],
      ),
    );
  }
}
