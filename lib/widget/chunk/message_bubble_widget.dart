import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/model/data_transfer/attachment.dart';
import 'package:lk_client/model/data_transfer/external_link.dart';
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/widget/chunk/file_download_widget.dart';

class MessageBubbleWidget extends StatelessWidget {
  final String messageText;
  final Attachment messageAttachment;
  final ExternalLink messageExternalLink;
  final bool sentByMe;
  final Person sender;
  final DateTime sentTime;

  MessageBubbleWidget({
    Key key, 
    @required this.messageText, 
    @required this.sentByMe,
    @required this.sentTime,
    this.messageAttachment, 
    this.messageExternalLink,
    this.sender
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: this.sentByMe ? Alignment.topRight : Alignment.topLeft,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: this.sentByMe ? Color.fromRGBO(204, 228, 255, 1.0) : Color.fromRGBO(236, 237, 241, 1.0)
        ),
        padding: EdgeInsets.all(10),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
          child: Column(
            crossAxisAlignment: this.sentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: () {
              List<Widget> messageBodyChildren = [];
              if(this.sender != null) {
                messageBodyChildren.add(
                  Text(
                    sender.name, 
                    style: TextStyle(color: Colors.lightBlue.shade700, fontSize: 10.0, fontWeight: FontWeight.w400), 
                  )
                );
                messageBodyChildren.add(SizedBox(height: 4,));
              }
              
              messageBodyChildren.add(Text(this.messageText, style: TextStyle(fontSize: 16, color: Colors.grey.shade900),));
              messageBodyChildren.add(SizedBox(height: 3,));

              final addZeros = (value) => value.toString().length == 1 ? '0' + value.toString() : value.toString();
              messageBodyChildren.add(
                Text('${addZeros(this.sentTime.day)}.${addZeros(this.sentTime.month)}.${this.sentTime.year} ${addZeros(this.sentTime.hour)}:${addZeros(this.sentTime.minute)}',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w300, color: Colors.grey.shade600),
                )
              );
              return messageBodyChildren;
            }(),
          ),
        )
      ),
    );
  }
}