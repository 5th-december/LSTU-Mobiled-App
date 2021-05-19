

import 'package:flutter/foundation.dart';
import 'package:lk_client/bloc/authentication/authentication_bloc.dart';
import 'package:lk_client/bloc/authentication/identification_bloc.dart';
import 'package:lk_client/bloc/authentication/login_bloc.dart';
import 'package:lk_client/bloc/authentication/registration_bloc.dart';
import 'package:lk_client/bloc/navigation_bloc.dart';

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
