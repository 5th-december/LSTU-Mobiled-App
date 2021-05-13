import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/widget/form/attached_message_input_widget.dart';
import 'package:lk_client/widget/list/dialog_list.dart';

class MessengerPage extends StatefulWidget {
  final Person currentUser;

  MessengerPage(this.currentUser);
  
  @override
  _MessengerPageState createState() => _MessengerPageState();
}

class _MessengerPageState extends State<MessengerPage> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Сообщения')),
      body: DialogList()
    );
  }
}
