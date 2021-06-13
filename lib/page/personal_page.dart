import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lk_client/bloc/loader/loader_bloc.dart';
import 'package:lk_client/command/consume_command.dart';
import 'package:lk_client/event/authentication_event.dart';
import 'package:lk_client/event/consuming_event.dart';
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/page/achievements_page.dart';
import 'package:lk_client/page/person_edit_page.dart';
import 'package:lk_client/page/publications_page.dart';
import 'package:lk_client/state/consuming_state.dart';
import 'package:lk_client/store/global/app_state_container.dart';
import 'package:lk_client/store/local/profile_page_provider.dart';
import 'package:lk_client/widget/layout/education_details.dart';
import 'package:lk_client/widget/layout/profile_picture.dart';
import 'package:lk_client/widget/util/bottom_navigator.dart';
import 'package:url_launcher/url_launcher.dart';

class PersonalPage extends StatefulWidget {
  final Person _person;

  PersonalPage(this._person);

  @override
  _PersonalPageState createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  PersonalDetailsLoaderBloc _bloc;

  Person get _person => widget._person;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (this._bloc == null) {
      this._bloc = ProfilePageProvider.of(context).personalDetailsLoaderBloc;
    }
  }

  List<Widget> _constructPersonProperties(Person person) {
    List<Widget> personProperties = [];

    if (person.sex != null) {
      personProperties.add(Row(
        children: [
          Icon(Icons.face_rounded, size: 22.0),
          Padding(
            padding: EdgeInsets.only(left: 12.0),
            child: Container(
              child: Text(
                'Пол: ${person.sex}',
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
          )
        ],
      ));
    }

    if (person.birthday != null) {
      final DateFormat formatter = DateFormat('dd.MM.yyyy');

      personProperties.add(Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: Row(
            children: [
              Icon(Icons.cake_rounded, size: 22.0),
              Padding(
                padding: EdgeInsets.only(left: 12.0),
                child: Container(
                  child: Text(
                    'Дата рождения: ${formatter.format(person.birthday)}',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
              ),
            ],
          )));
    }

    if (person.phone != null) {
      personProperties.add(Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: Row(
            children: [
              Icon(Icons.call_rounded, size: 22.0),
              Padding(
                padding: EdgeInsets.only(left: 12.0),
                child: GestureDetector(
                  child: Container(
                    child: Text(
                      'Телефон: ${person.phone}',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                  onTap: () async {
                    var phoneCallerUri = 'tel:${person.phone}';
                    if (await canLaunch(phoneCallerUri)) {
                      await launch(phoneCallerUri);
                    } else {
                      throw Exception('Can not call');
                    }
                  },
                ),
              )
            ],
          )));
    }

    if (person.email != null) {
      personProperties.add(Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Row(
          children: [
            Icon(Icons.email_rounded, size: 22.0),
            Padding(
              padding: EdgeInsets.only(left: 12.0),
              child: GestureDetector(
                child: Container(
                  child: Text(
                    'E-mail: ${person.email}',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
                onTap: () async {
                  var emailUri = 'mailto:${person.email}';
                  if (await canLaunch(emailUri)) {
                    await launch(emailUri);
                  } else {
                    throw Exception('Can not send email');
                  }
                },
              ),
            )
          ],
        ),
      ));
    }

    if (person.messenger != null) {
      personProperties.add(Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Row(
          children: [
            Icon(Icons.send_rounded, size: 22.0),
            Padding(
              padding: EdgeInsets.only(left: 12.0),
              child: Container(
                child: Text(
                  'Мессенджер: ${person.messenger}',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
            ),
          ],
        ),
      ));
    }

    return personProperties;
  }

  Widget build(BuildContext context) {
    this._bloc.eventController.sink.add(StartConsumeEvent<LoadPersonDetails>(
        request: LoadPersonDetails(_person)));

    return Scaffold(
        appBar: AppBar(
          title: Text('Персональная страница'),
          actions: [
            IconButton(
                icon: Icon(Icons.logout),
                onPressed: () {
                  AppStateContainer.of(context)
                      .blocProvider
                      .authenticationBloc
                      .eventController
                      .sink
                      .add(LoggedOutEvent());
                })
          ],
        ),
        body: StreamBuilder(
          stream: this._bloc.consumingStateStream,
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.data is ConsumingReadyState<Person>) {
              Person loadedPerson =
                  (snapshot.data as ConsumingReadyState<Person>).content;

              return ListView(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 30.0),
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PersonProfilePicture(
                            displayed: this._person, size: 50.0),
                        Expanded(
                            flex: 1,
                            child: Container(
                              padding: EdgeInsets.only(left: 20.0, top: 5.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    '${loadedPerson.surname} ${loadedPerson.name} ${loadedPerson.patronymic}',
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        Theme.of(context).textTheme.headline3,
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(top: 8.0),
                                      child: ElevatedButton(
                                          onPressed: () {
                                            final personalDetailsLoaderBloc =
                                                ProfilePageProvider.of(context)
                                                    .personalDetailsLoaderBloc;
                                            final personalDataFormBloc =
                                                ProfilePageProvider.of(context)
                                                    .personalDataFormBloc;
                                            Navigator.of(context).push(MaterialPageRoute(
                                                builder: (BuildContext
                                                        context) =>
                                                    PersonEditPage(
                                                        personalDataFormBloc:
                                                            personalDataFormBloc,
                                                        personalDetailsLoaderBloc:
                                                            personalDetailsLoaderBloc,
                                                        person: loadedPerson)));
                                          },
                                          child: Text('Редактировать')))
                                ],
                              ),
                            ))
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(18.0),
                    child: Column(
                      children: this._constructPersonProperties(loadedPerson),
                    ),
                  ),
                  Divider(),
                  Container(
                    padding: EdgeInsets.only(top: 18.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 5.0, bottom: 5.0, left: 10.0),
                              child: Text(
                                'Образование',
                                style: Theme.of(context).textTheme.subtitle2,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.0),
                        EducationDetails(widget._person),
                        SizedBox(
                          height: 12.0,
                        )
                      ],
                    ),
                  ),
                  Divider(),
                  ListView(
                    shrinkWrap: true,
                    children: [
                      SizedBox(
                        height: 18.0,
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                top: 5.0, bottom: 5.0, left: 10.0),
                            child: Text(
                              'Действия',
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.0),
                      Container(
                        child: ListTile(
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromRGBO(165, 153, 255, 1.0)),
                            child: Center(
                              child: Icon(
                                Icons.emoji_events_rounded,
                                color: Colors.white,
                                size: 30.0,
                              ),
                            ),
                          ),
                          title: Text('Личные достижения'),
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      AchievementsPage(
                                        person: widget._person,
                                      ))),
                        ),
                      ),
                      Container(
                        child: ListTile(
                          title: Text('Публикации'),
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromRGBO(165, 153, 255, 1.0)),
                            child: Center(
                              child: Icon(
                                Icons.auto_stories,
                                color: Colors.white,
                                size: 30.0,
                              ),
                            ),
                          ),
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      PublicationsPage(
                                          person: widget._person))),
                        ),
                      ),
                      SizedBox(
                        height: 12.0,
                      )
                    ],
                  )
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
        bottomNavigationBar: BottomNavigator());
  }
}
