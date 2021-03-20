import 'package:flutter/material.dart';
import 'package:lk_client/page/basic/centered_form_page_skeleton.dart';
import 'package:lk_client/widget/identify_form_widget.dart';
import 'package:lk_client/widget/login_form_widget.dart';
import 'package:lk_client/widget/register_form_widget.dart';


class LoginPage extends StatelessWidget 
{
  @override
  Widget build(BuildContext context) => CenteredFormPageSkeleton(centeredForm: LoginFormWidget()); 
}

class RegisterPage extends StatelessWidget 
{
  @override
  Widget build(BuildContext context) => CenteredFormPageSkeleton(centeredForm: RegisterFormWidget()); 
}

class IdentificationPage extends StatelessWidget 
{
  @override
  Widget build(BuildContext context) => CenteredFormPageSkeleton(centeredForm: UserIdentifyFormWidget());
}