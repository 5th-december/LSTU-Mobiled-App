import 'package:flutter/material.dart';
import 'basic/page_skeleton.dart';
import '../widget/login_form_widget.dart';
import '../widget/register_form_widget.dart';

class LoginPage extends StatelessWidget
{
  @override 
  Widget build(BuildContext context) => AuthorizationPage(LoginFormWidget());
}

class RegisterPage extends StatelessWidget
{
  @override 
  Widget build(BuildContext context) => AuthorizationPage(RegisterFormWidget());
}

class AuthorizationPage extends StatefulWidget
{
  final Widget authorizationForm;

  AuthorizationPage(this.authorizationForm);

  @override
  _AuthorizationPage createState() => _AuthorizationPage(this.authorizationForm);
}

class _AuthorizationPage extends State<AuthorizationPage> {
  
  Widget authorizationForm;

  String authorizationActionName;

  String defineOppositeAuthorizationActionName() {
    if (this.authorizationForm.runtimeType == LoginFormWidget) {
      return 'Регистрация';
    } else if (this.authorizationForm.runtimeType == RegisterFormWidget) {
      return 'Войти';
    } else {
      throw new TypeError();
    }
  }

  void changeAuthorizationType() {
    setState(() {
      if (this.authorizationForm.runtimeType == LoginFormWidget) {
        this.authorizationForm = RegisterFormWidget();
      } else if (this.authorizationForm.runtimeType == RegisterFormWidget) {
        this.authorizationForm = LoginFormWidget();
      }
      this.authorizationActionName = defineOppositeAuthorizationActionName();
    });
  }

  _AuthorizationPage(this.authorizationForm) {
    this.authorizationActionName = defineOppositeAuthorizationActionName();
  }

  Widget build(BuildContext context) {
    return PageSkeleton(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.2
            ),
            child: Column(
              children: [
                this.authorizationForm,
                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: FlatButton(
                    onPressed: this.changeAuthorizationType,
                    child: Text(this.authorizationActionName),
                  ),
                )
              ],
            ),
          )
        ],
      )
    );
  }

}