import 'package:flutter/cupertino.dart';
import 'package:lk_client/model/entity/person_entity.dart';

class MessengerPage extends StatefulWidget {
  PersonEntity currentUser;

  MessengerPage(this.currentUser);
  
  @override
  _MessengerPageState createState() => _MessengerPageState();
}

class _MessengerPageState extends State<MessengerPage> {
  Widget build(BuildContext context) {
    return Center(child: Text('This is messenger page'));
  }
}
