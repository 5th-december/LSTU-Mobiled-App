import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/command/consume_command.dart';
import 'package:lk_client/event/consuming_event.dart';
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/store/local/profile_page_provider.dart';
import 'package:lk_client/widget/list/achievements_list.dart';
import 'package:lk_client/widget/util/bottom_navigator.dart';

class AchievementsPage extends StatefulWidget {
  final Person person;

  AchievementsPage({Key key, @required this.person}) : super(key: key);

  @override
  _AchievementsPageState createState() => _AchievementsPageState();
}

class _AchievementsPageState extends State<AchievementsPage> {
  @override
  Widget build(BuildContext context) {
    final achievementsListLoaderBloc =
        ProfilePageProvider.of(context).achievementsListLoaderBloc;

    achievementsListLoaderBloc.eventController.sink.add(
        StartConsumeEvent<LoadAchievementsListCommand>(
            request: LoadAchievementsListCommand(person: widget.person)));

    return Scaffold(
      appBar: AppBar(title: Text('Личные достижения')),
      body: AchievementsList(
          person: widget.person,
          achievementsListLoaderBloc: achievementsListLoaderBloc),
      bottomNavigationBar: BottomNavigator(),
    );
  }
}
