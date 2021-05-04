import 'package:lk_client/bloc/authentication_bloc.dart';

import 'package:flutter/material.dart';
import 'package:lk_client/bloc/identification_bloc.dart';
import 'package:lk_client/bloc/login_bloc.dart';
import 'package:lk_client/bloc/navigation_bloc.dart';
import 'package:lk_client/bloc/registration_bloc.dart';

class BlocProvider {
  final AuthenticationBloc authenticationBloc;
  final LoginBloc loginBloc;
  final RegistrationBloc registrationBloc;
  final IdentificationBloc identificationBloc;
  final NavigationBloc navigationBloc;

  BlocProvider(
      {@required this.authenticationBloc,
      @required this.loginBloc,
      @required this.registrationBloc,
      @required this.identificationBloc,
      @required this.navigationBloc});
}
