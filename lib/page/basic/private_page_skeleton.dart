import 'package:flutter/cupertino.dart';
import 'package:lk_client/bloc/authentication/authentication_bloc.dart';
import 'package:lk_client/page/basic/fullscreen_loading_page.dart';
import 'package:lk_client/page/register_page.dart';
import 'package:lk_client/page/togglable_login_page.dart';
import 'package:lk_client/state/authentication_state.dart';
import 'package:lk_client/store/app_state_container.dart';

class PrivatePageSkeleton extends StatefulWidget {
  Widget page;

  PrivatePageSkeleton(this.page);

  @override
  _PrivatePageSkeletonState createState() => _PrivatePageSkeletonState();
}

class _PrivatePageSkeletonState extends State<PrivatePageSkeleton> {
  Widget get page => widget.page;

  @override
  Widget build(BuildContext context) {
    AuthenticationBloc appAuthenticationBloc =
        AppStateContainer.of(context).blocProvider.authenticationBloc;

    return StreamBuilder(
        stream: appAuthenticationBloc.state,
        builder: (BuildContext context,
            AsyncSnapshot<AuthenticationState> snapshot) {
          AuthenticationState state = snapshot.data;

          if (state is AuthenticationIdentifiedState) {
            
            return RegisterPage();

          } else if (state is AuthenticationUnauthorizedState) {

            return TogglableLoginPage();

          } else if (state is AuthenticationProcessingState || state is AuthenticationInvalidState) {

            return FullscreenLoadingPage();

          } else if (state is AuthenticationValidState) {

            return this.page;
            
          }

          return FullscreenLoadingPage();
        });
  }
}
