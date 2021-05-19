import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/bloc/abstract_bloc.dart';
import 'package:lk_client/bloc/attached/personal_data_form_bloc.dart';
import 'package:lk_client/bloc/loader/loader_bloc.dart';
import 'package:lk_client/command/consume_command.dart';
import 'package:lk_client/command/produce_command.dart';
import 'package:lk_client/event/consuming_event.dart';
import 'package:lk_client/event/producing_event.dart';
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/model/person/personal_data.dart';
import 'package:lk_client/state/producing_state.dart';
import 'package:lk_client/store/local/profile_page_provider.dart';
import 'package:lk_client/widget/chunk/centered_loader.dart';

class PersonEditPage extends StatefulWidget {
  final Person person;

  PersonEditPage({Key key, @required this.person}) : super(key: key);

  @override
  _PersonEditPageState createState() => _PersonEditPageState();
}

class _PersonEditPageState extends State<PersonEditPage> {
  PersonalDataFormBloc _personalDataFormBloc;
  PersonalDetailsLoaderBloc _personalDetailsLoaderBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (this._personalDataFormBloc == null) {
      this._personalDataFormBloc =
          ProfilePageProvider.of(context).personalDataFormBloc;
    }

    if (this._personalDetailsLoaderBloc == null) {
      this._personalDetailsLoaderBloc =
          ProfilePageProvider.of(context).personalDetailsLoaderBloc;
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _editFormKey = GlobalKey<FormState>();

    final phoneEditingController = TextEditingController();
    final emailEditionController = TextEditingController();
    final messengerEditionController = TextEditingController();

    if (widget.person != null) {
      phoneEditingController.text = widget.person.phone;
      emailEditionController.text = widget.person.email;
      messengerEditionController.text = widget.person.messenger;
    }

    this
        ._personalDataFormBloc
        .eventController
        .sink
        .add(ProducerInitEvent<PersonalData>());

    return Scaffold(
        appBar: AppBar(title: Text('Редактирование профиля')),
        body: StreamBuilder(
            stream: this._personalDataFormBloc.personalDataUpdateStateStream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                final state = snapshot.data;

                if (state is ProducingReadyState<PersonalData, bool>) {
                  this._personalDetailsLoaderBloc.eventController.sink.add(
                      StartConsumeEvent<LoadPersonDetails>(
                          request: LoadPersonDetails(widget.person)));
                  Navigator.of(context).pop();
                }

                return Stack(children: [
                  Padding(
                      padding:
                          EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
                      child: ListView(children: [
                        Form(
                          key: _editFormKey,
                          child: Column(
                            children: [
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Телефон',
                                  errorText: state
                                          is ProducingInvalidState<PersonalData>
                                      ? state.errorBox
                                          .getFirstForField('phone')
                                          ?.message
                                      : null,
                                ),
                                controller: phoneEditingController,
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'E-mail',
                                  errorText: state
                                          is ProducingInvalidState<PersonalData>
                                      ? state.errorBox
                                          .getFirstForField('email')
                                          ?.message
                                      : null,
                                ),
                                controller: emailEditionController,
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Мессенджер',
                                  errorText: state
                                          is ProducingInvalidState<PersonalData>
                                      ? state.errorBox
                                          .getFirstForField('messenger')
                                          ?.message
                                      : null,
                                ),
                                controller: messengerEditionController,
                              ),
                              Padding(
                                  padding: EdgeInsets.only(top: 30.0),
                                  child: () {
                                    if (state is ProducingLoadingState<
                                        PersonalData>) {
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [CircularProgressIndicator()],
                                      );
                                    } else if (state
                                        is ProducingErrorState<PersonalData>) {
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text('Ошибка добавления данных')
                                        ],
                                      );
                                    }
                                  }())
                            ],
                          ),
                        )
                      ])),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      child: Text('Сохранить'),
                      onPressed: () {
                        PersonalData personalData = PersonalData();
                        if (emailEditionController.text != '') {
                          personalData.email = emailEditionController.text;
                        }
                        if (phoneEditingController.text != '') {
                          personalData.phone = phoneEditingController.text;
                        }
                        if (messengerEditionController.text != '') {
                          personalData.messenger =
                              messengerEditionController.text;
                        }

                        this._personalDataFormBloc.eventController.sink.add(
                            ProduceResourceEvent<PersonalData,
                                    UpdateProfileInformation>(
                                command: UpdateProfileInformation(),
                                resource: personalData));
                      },
                    ),
                  )
                ]);
              }

              return CenteredLoader();
            }));
  }
}
