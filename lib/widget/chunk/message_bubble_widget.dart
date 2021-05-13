import 'package:flutter/widgets.dart';
import 'package:lk_client/model/data_transfer/attachment.dart';
import 'package:lk_client/model/data_transfer/external_link.dart';
import 'package:lk_client/model/person/person.dart';

class MessageBubbleWidget extends StatelessWidget {
  final String messageText;
  final Attachment messageAttachment;
  final ExternalLink messageExternalLink;
  final bool sentByMe;
  final Person sender;

  MessageBubbleWidget({
    Key key, 
    @required this.messageText, 
    @required this.sentByMe,
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
          color: this.sentByMe ? Color.fromARGB(1, 204, 228, 255) : Color.fromARGB(1, 236, 237, 241)
        ),
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Text(this.messageText)
          ],
        ),
      ),
    );
  }
}