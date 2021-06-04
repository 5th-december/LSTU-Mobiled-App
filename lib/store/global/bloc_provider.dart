import 'package:flutter/foundation.dart';
import 'package:lk_client/bloc/authentication/authentication_bloc.dart';
import 'package:lk_client/bloc/navigation_bloc.dart';
import 'package:lk_client/bloc/notification_prefs_bloc.dart';

class BlocProvider {
  final AuthenticationBloc authenticationBloc;
  final NavigationBloc navigationBloc;
  final NotificationPrefsBloc notificationPrefsBloc;

  BlocProvider(
      {@required this.authenticationBloc,
      @required this.notificationPrefsBloc,
      @required this.navigationBloc});
}
