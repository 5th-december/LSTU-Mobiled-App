import 'package:flutter/material.dart';

class LoginFormWidget extends StatelessWidget
{
  LoginFormWidget();

  @override 
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Form(
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Имя пользователя'
                ),
              ),
              TextFormField(
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: 'Пароль'
                )
              ),
              Padding(
                padding: EdgeInsets.only(top: 15),
                child: RaisedButton(
                  onPressed: null,
                  child: Text('Вход'),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}