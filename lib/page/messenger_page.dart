import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/page/person_finder_page.dart';
import 'package:lk_client/widget/list/dialog_list.dart';
import 'package:lk_client/widget/util/bottom_navigator.dart';

class MessengerPage extends StatefulWidget {
  final Person currentUser;

  MessengerPage(this.currentUser);

  @override
  _MessengerPageState createState() => _MessengerPageState();
}

class _MessengerPageState extends State<MessengerPage> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Сообщения'),
        actions: [
          IconButton(
              icon: Icon(Icons.person_add_alt_1_rounded),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => PersonFinderPage())))
        ],
      ),
      body: DialogList(
        person: widget.currentUser,
      ),
      bottomNavigationBar: BottomNavigator(),
    );
  }
}
