import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/model/person/person.dart';

class MessageBubbleWidget extends StatelessWidget {
  final String messageText;
  final Widget attachmentWidget;
  final bool sentByMe;
  final Person sender;
  final DateTime sentTime;
  final bool isRead;

  MessageBubbleWidget(
      {Key key,
      @required this.messageText,
      @required this.sentByMe,
      @required this.sentTime,
      this.isRead,
      this.attachmentWidget,
      this.sender})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment:
            this.sentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        textDirection: this.sentByMe ? TextDirection.ltr : TextDirection.rtl,
        mainAxisSize: MainAxisSize.min,
        children: [
          !this.isRead && !this.sentByMe
              ? Container(
                  height: 10.0,
                  width: 10.0,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromRGBO(139, 63, 246, 1.0)),
                )
              : SizedBox.shrink(),
          SizedBox(
            width: 10.0,
          ),
          Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: this.sentByMe
                      ? Color.fromRGBO(243, 243, 243, 1.0)
                      : Color.fromRGBO(225, 193, 250, 1.0)),
              padding: EdgeInsets.all(10),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7),
                child: Column(
                  crossAxisAlignment: this.sentByMe
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: () {
                    List<Widget> messageBodyChildren = [];
                    if (this.sender != null) {
                      messageBodyChildren.add(Text(
                        "${sender.name} ${sender.surname}",
                        style: TextStyle(
                            color: Color.fromRGBO(139, 62, 252, 1.0),
                            fontSize: 12.0,
                            fontWeight: FontWeight.w400),
                      ));
                      messageBodyChildren.add(SizedBox(
                        height: 4,
                      ));
                    }

                    if (this.messageText != null) {
                      messageBodyChildren.add(Text(
                        this.messageText,
                        style: TextStyle(
                            fontSize: 16, color: Colors.grey.shade900),
                      ));
                      messageBodyChildren.add(SizedBox(height: 3));
                    }

                    if (this.attachmentWidget != null) {
                      messageBodyChildren.add(this.attachmentWidget);
                    }

                    final addZeros = (value) => value.toString().length == 1
                        ? '0' + value.toString()
                        : value.toString();
                    messageBodyChildren.add(Text(
                      '${addZeros(this.sentTime.day)}.${addZeros(this.sentTime.month)}.${this.sentTime.year} ${addZeros(this.sentTime.hour)}:${addZeros(this.sentTime.minute)}',
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade600),
                    ));
                    return messageBodyChildren;
                  }(),
                ),
              )),
        ]);
  }
}
