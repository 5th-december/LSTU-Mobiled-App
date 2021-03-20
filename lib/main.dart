import 'package:flutter/material.dart';
import 'package:lk_client/bloc/authentication_bloc.dart';
import 'package:lk_client/bloc/identification_bloc.dart';
import 'package:lk_client/bloc/login_bloc.dart';
import 'package:lk_client/bloc/registration_bloc.dart';
import 'package:lk_client/service/app_config.dart';
import 'package:lk_client/service/http/authorization_service.dart';
import 'package:lk_client/service/jwt_manager.dart';
import 'package:lk_client/store/bloc_provider.dart';
import 'app.dart';
import 'store/app_state_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appEnv = 'dev';
  AppConfig config = await AppConfig.configure(env: appEnv);
  AuthorizationService appAuthorizationService = AuthorizationService(config);

  AuthenticationBloc appAuthenticationBloc = AuthenticationBloc(jwtManager: JwtManager.instance);
  LoginBloc appLoginBloc = LoginBloc(authorizationService: appAuthorizationService, 
    authenticationBloc: appAuthenticationBloc);

  RegistrationBloc appRegistrationBloc = RegistrationBloc(appAuthorizationService, appAuthenticationBloc);
  IdentificationBloc appIdentificationBloc = IdentificationBloc(appAuthorizationService, appRegistrationBloc);

  BlocProvider blocProvider = BlocProvider(
    authenticationBloc: appAuthenticationBloc,
    loginBloc: appLoginBloc,
    registrationBloc: appRegistrationBloc,
    identificationBloc: appIdentificationBloc
  );

  runApp(AppStateContainer(
    child: LkApp(),
    blocProvider: blocProvider,
  ));
}
