import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lk_client/command/consume_command.dart';
import 'package:lk_client/event/consuming_event.dart';
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/store/local/profile_page_provider.dart';
import 'package:lk_client/widget/list/publications_list.dart';

class PublicationsPage extends StatefulWidget {
  final Person person;

  PublicationsPage({Key key, @required this.person}) : super(key: key);

  @override
  _PublicationsPageState createState() => _PublicationsPageState();
}

class _PublicationsPageState extends State<PublicationsPage> {
  @override
  Widget build(BuildContext context) {
    final publicationsListLoaderBloc =
        ProfilePageProvider.of(context).publicationsListLoaderBloc;

    publicationsListLoaderBloc.eventController.sink.add(
        StartConsumeEvent<LoadPublicationsListCommand>(
            request: LoadPublicationsListCommand(person: widget.person)));

    return Scaffold(
        appBar: AppBar(title: Text('Публикации')),
        body: PublicationsList(
          person: widget.person,
          publicationsListLoaderBloc: publicationsListLoaderBloc,
        ));
  }
}
