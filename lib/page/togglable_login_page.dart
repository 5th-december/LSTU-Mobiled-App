import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/store/global/app_state_container.dart';
import 'package:lk_client/widget/form/identify_form.dart';
import 'package:lk_client/widget/form/login_form.dart';

enum DisplayedLoginType { loginPage, registerPage }

class TogglableLoginPage extends StatefulWidget {
  final DisplayedLoginType initLoginType;

  TogglableLoginPage({this.initLoginType = DisplayedLoginType.registerPage});

  @override
  _TogglableLoginPageState createState() =>
      _TogglableLoginPageState(this.initLoginType);
}

class _TogglableLoginPageState extends State<TogglableLoginPage> {
  DisplayedLoginType type;

  _TogglableLoginPageState(this.type);

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
              Visibility(
                  maintainState: true,
                  visible: this.type == DisplayedLoginType.registerPage,
                  child: IdentifyForm(AppStateContainer.of(context)
                      .serviceProvider
                      .authorizationService)),
              Visibility(
                  maintainState: true,
                  visible: this.type == DisplayedLoginType.loginPage,
                  child: LoginForm(AppStateContainer.of(context)
                      .serviceProvider
                      .authorizationService)),
              ElevatedButton(
                  child: Text(this.type == DisplayedLoginType.loginPage
                      ? 'Регистрация'
                      : 'Войти'),
                  onPressed: () {
                    setState(() {
                      this.type = this.type == DisplayedLoginType.loginPage
                          ? DisplayedLoginType.registerPage
                          : DisplayedLoginType.loginPage;
                    });
                  })
            ],
          ),
        ),
      ],
    ));
  }
}
