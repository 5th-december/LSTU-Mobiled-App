import 'package:flutter/material.dart';
import 'package:lk_client/bloc/authentication_bloc.dart';
import 'package:lk_client/bloc/identification_bloc.dart';
import 'package:lk_client/event/identify_event.dart';
import 'package:lk_client/service/http/authorization_service.dart';
import 'package:lk_client/state/identify_state.dart';
import 'package:lk_client/store/app_state_container.dart';

class UserIdentifyFormWidget extends StatefulWidget {
  AuthorizationService _authorizationService;

  UserIdentifyFormWidget(this._authorizationService);

  @override
  _UserIdentifyFormWidgetState createState() => _UserIdentifyFormWidgetState();
}

class _UserIdentifyFormWidgetState extends State<UserIdentifyFormWidget> {
  final _usernameEditingController = TextEditingController();
  final _zBookNumberEditingController = TextEditingController();
  final _enterYearEditingController = TextEditingController();
  GlobalKey<FormState> _stateKey = GlobalKey<FormState>();

  AuthorizationService get authorizationService => widget._authorizationService;

  IdentificationBloc _identificationBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (this._identificationBloc == null) {
      AuthenticationBloc authenticationBloc =
          AppStateContainer.of(context).blocProvider.authenticationBloc;
      this._identificationBloc =
          new IdentificationBloc(authorizationService, authenticationBloc);
    }
  }

  @override
  dispose() async {
    await this._identificationBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 40),
          child: Form(
            key: _stateKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'ФИО', hintText: 'Иванов Иван Иванович'),
                  autofocus: true,
                  controller: _usernameEditingController,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Номер зачетной книжки', hintText: '12345678'),
                  controller: _zBookNumberEditingController,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Год поступления', hintText: '2017'),
                  controller: _enterYearEditingController,
                ),
                Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: StreamBuilder<IdentifyState>(
                        stream: _identificationBloc.state,
                        builder: (BuildContext context,
                            AsyncSnapshot<IdentifyState>
                                registerStateSnapshot) {
                          if (registerStateSnapshot.connectionState ==
                              ConnectionState.active) {
                            var receivedState = registerStateSnapshot.data;

                            if (receivedState is IdentifyProcessingState) {
                              return Container(
                                  child: Center(
                                child: CircularProgressIndicator(),
                              ));
                            } else if (receivedState is IdentifyErrorState) {
                              _onWidgetDidBuild(() {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${receivedState.error}'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              });
                            }
                          }

                          return ElevatedButton(
                              onPressed: () {
                                _identificationBloc.eventController.sink.add(
                                    IdentificationButtonPressedEvent(
                                        name: this
                                            ._usernameEditingController
                                            .text,
                                        enterYear: int.parse(
                                            _enterYearEditingController.text),
                                        zBookNumber: this
                                            ._zBookNumberEditingController
                                            .text));
                              },
                              child: Text('Регистрация'));
                        }))
              ],
            ),
          ),
        )
      ],
    );
  }

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }
}
