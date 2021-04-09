import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/bloc/authentication/authentication_bloc.dart';
import 'package:lk_client/event/authentication_event.dart';
import 'package:lk_client/store/app_state_container.dart';
import 'package:lk_client/widget/authentication/register_form_widget.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.2),
          child: Column(
            children: [
              RegisterFormWidget(AppStateContainer.of(context)
                  .serviceProvider
                  .authorizationService),
              ElevatedButton(
                  onPressed: () => {
                        AppStateContainer.of(context)
                            .blocProvider
                            .authenticationBloc
                            .eventController
                            .add(LoggedOutEvent())
                      },
                  child: Text('Отмена'))
            ],
          ),
        ),
      ],
    ));
  }
}
