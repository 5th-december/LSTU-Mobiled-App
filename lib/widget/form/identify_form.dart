import 'package:flutter/material.dart';
import 'package:lk_client/bloc/authentication/authentication_bloc.dart';
import 'package:lk_client/bloc/authentication/identification_bloc.dart';
import 'package:lk_client/error_handler/api_system_error_handler.dart';
import 'package:lk_client/error_handler/duplicate_error_handler.dart';
import 'package:lk_client/error_handler/not_found_error_handler.dart';
import 'package:lk_client/event/identify_event.dart';
import 'package:lk_client/service/api_consumer/authorization_service.dart';
import 'package:lk_client/state/identify_state.dart';
import 'package:lk_client/store/global/app_state_container.dart';
import 'package:lk_client/widget/chunk/form/semitransparent_text_form_field.dart';

class IdentifyForm extends StatefulWidget {
  final AuthorizationService _authorizationService;

  IdentifyForm(this._authorizationService);

  @override
  _IdentifyFormState createState() => _IdentifyFormState();
}

class _IdentifyFormState extends State<IdentifyForm> {
  final _usernameEditingController = TextEditingController();
  final _zBookNumberEditingController = TextEditingController();
  final _enterYearEditingController = TextEditingController();
  GlobalKey<FormState> _stateKey = GlobalKey<FormState>();

  AuthorizationService get authorizationService => widget._authorizationService;

  IdentificationBloc _identificationBloc;

  String _nameInputErrorLabel, _zBookNumberErrorLabel, _enterYearErrorLabel;

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
    Future.delayed(Duration.zero, () async {
      await this._identificationBloc.dispose();
    });
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
                SemitransparentTextFormField(
                  hintText: 'Фамилия имя отчество',
                  autofocus: true,
                  errorText: _nameInputErrorLabel,
                  controller: _usernameEditingController,
                  icon: Icons.person_rounded,
                ),
                SizedBox(
                  height: 20.0,
                ),
                SemitransparentTextFormField(
                  hintText: 'Номер зачетной книжки',
                  controller: _zBookNumberEditingController,
                  errorText: _zBookNumberErrorLabel,
                  icon: Icons.source_rounded,
                ),
                SizedBox(
                  height: 20.0,
                ),
                SemitransparentTextFormField(
                  hintText: 'Год поступления',
                  controller: _enterYearEditingController,
                  errorText: _enterYearErrorLabel,
                  icon: Icons.calendar_today_rounded,
                ),
                SizedBox(
                  height: 20.0,
                ),
                Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: StreamBuilder<IdentifyState>(
                        stream: _identificationBloc.state,
                        builder: (BuildContext context,
                            AsyncSnapshot<IdentifyState>
                                registerStateSnapshot) {
                          final identifyChildWidgets = <Widget>[];

                          if (registerStateSnapshot.connectionState ==
                              ConnectionState.active) {
                            var receivedState = registerStateSnapshot.data;

                            if (receivedState is IdentifyProcessingState) {
                              return Container(
                                  child: Center(
                                child: CircularProgressIndicator(),
                              ));
                            }

                            if (receivedState is IdentifyErrorState) {
                              final error = receivedState.error;

                              identifyChildWidgets.add(
                                Text(
                                  () {
                                    if (error is NotFoundException) {
                                      return 'Указанные данные недействительны.\nПроверьте учетную информацию';
                                    } else if (error is DuplicateException) {
                                      return 'Этот пользователь уже зарегистрирован';
                                    } else if (error is ApiSystemException) {
                                      return 'Внутренняя ошибка сервиса';
                                    } else {
                                      return 'Ошибка';
                                    }
                                  }(),
                                  style: Theme.of(context).textTheme.subtitle2,
                                ),
                              );
                            }
                          }

                          identifyChildWidgets.add(Padding(
                              padding: EdgeInsets.only(top: 15.0),
                              child: ElevatedButton(
                                  onPressed: () {
                                    bool valid = true;
                                    setState(() {
                                      final username =
                                          this._usernameEditingController.text;
                                      this._nameInputErrorLabel = null;
                                      if (username == '') {
                                        this._nameInputErrorLabel =
                                            'Заполните ФИО';
                                        valid = false;
                                      }

                                      final enterYear =
                                          this._enterYearEditingController.text;
                                      RegExp yearRegexp = RegExp(r'^\d{4}$');

                                      this._enterYearErrorLabel = null;

                                      if (enterYear == '') {
                                        this._enterYearErrorLabel =
                                            'Заполните год поступления';
                                        valid = false;
                                      } else if (!yearRegexp
                                          .hasMatch(enterYear)) {
                                        this._enterYearErrorLabel =
                                            'Неверно указан год поступления';
                                        valid = false;
                                      }
                                      final zBookNumber = this
                                          ._zBookNumberEditingController
                                          .text;

                                      this._zBookNumberErrorLabel = null;

                                      if (zBookNumber == '') {
                                        this._zBookNumberErrorLabel =
                                            'Укажите номер зачетной книжки';
                                        valid = false;
                                      }
                                    });

                                    if (!valid) {
                                      return;
                                    }

                                    _identificationBloc.eventController.sink
                                        .add(IdentificationButtonPressedEvent(
                                            name: this
                                                ._usernameEditingController
                                                .text,
                                            enterYear: int.parse(
                                                _enterYearEditingController
                                                    .text),
                                            zBookNumber: this
                                                ._zBookNumberEditingController
                                                .text));
                                  },
                                  child: Text('Регистрация'))));

                          return Column(
                            children: identifyChildWidgets,
                          );
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
