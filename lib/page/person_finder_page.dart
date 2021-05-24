import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/command/consume_command.dart';
import 'package:lk_client/event/endless_scrolling_event.dart';
import 'package:lk_client/store/local/person_finder_page_provider.dart';
import 'package:lk_client/widget/list/person_list.dart';
import 'package:lk_client/widget/util/bottom_navigator.dart';

class PersonFinderPage extends StatefulWidget {
  PersonFinderPage({Key key}) : super(key: key);

  @override
  _PersonFinderPageState createState() => _PersonFinderPageState();
}

class _PersonFinderPageState extends State<PersonFinderPage> {
  @override
  Widget build(BuildContext context) {
    return PersonFinderPageProvider(
        child: Scaffold(
      appBar: AppBar(title: Text('Поиск пользователей')),
      body: Column(
        children: [SearchString(), Expanded(child: PersonList())],
      ),
      bottomNavigationBar: BottomNavigator(),
    ));
  }
}

class SearchString extends StatelessWidget {
  SearchString({Key key}) : super(key: key);

  final queryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 7.0),
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: TextFormField(
            controller: queryController,
            decoration: InputDecoration(
              hintText: 'Введите имя пользователя',
              hintStyle:
                  TextStyle(color: Colors.black45, fontWeight: FontWeight.w400),
              border: InputBorder.none,
            ),
          )),
          IconButton(
              icon: Icon(Icons.search_rounded),
              onPressed: () {
                PersonFinderPageProvider.of(context)
                    .personListBloc
                    .eventController
                    .sink
                    .add(EndlessScrollingLoadEvent<LoadPersonListByTextQuery>(
                        command: LoadPersonListByTextQuery(
                            count: 50,
                            offset: 0,
                            textQuery: queryController.text)));
              })
        ],
      ),
    );
  }
}
