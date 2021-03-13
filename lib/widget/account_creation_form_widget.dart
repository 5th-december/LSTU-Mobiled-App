import 'package:flutter/material.dart';
import '../entity/authorization_data.dart';

class AccountCreationFormWidget extends StatefulWidget
{
  @override 
  _AccountCreationFormWidget createState() => _AccountCreationFormWidget();
}


class _AccountCreationFormWidget extends State<AccountCreationFormWidget>
{
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  void onSubmitButtonPressed() {
    if (_key.currentState.validate()) {
      AuthorizationData data = AuthorizationData(
        password: this._passwordTextEditingController.text,
        username: this._emailTextEditingController.text
      );

      
    }
  }

  final _emailTextEditingController = TextEditingController();
  final _passwordTextEditingController = TextEditingController();

  @override 
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Form(
          key: this._key,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Электронная почта'
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Введите адрес электронной почты';
                  }

                  RegExp emailValidationRegexp = RegExp(r"\w+@\w+\.\w+");
                  if (! emailValidationRegexp.hasMatch(value)) {
                    return 'Введенный адрес электронной почты имеет неверный формат';
                  }

                  return null;
                },
              ), 
              TextFormField(
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: 'Пароль'
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Значение пароля не может быть пустым';
                  } else if (value.length < 8){
                    return 'Минимальная длина пароля 8 символов';
                  }
                  return null;
                },
              ),
              TextFormField(
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: 'Повторите пароль'
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Введите повторный пароль';
                  } else if (value != this._passwordTextEditingController.text) {
                    return 'Пароли не совпадают';
                  }
                  return null;
                },
              ),
              RaisedButton(
                onPressed: this.onSubmitButtonPressed,
                child: Text('Регистрация'),
                
              )
            ],
          ),
        )
      ],
    );
  }
}