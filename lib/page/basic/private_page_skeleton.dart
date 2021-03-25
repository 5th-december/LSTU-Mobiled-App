import 'package:flutter/cupertino.dart';
import 'package:lk_client/bloc/authentication_bloc.dart';
import 'package:lk_client/event/authentication_event.dart';
import 'package:lk_client/page/basic/form_page_skeleton.dart';
import 'package:lk_client/page/basic/fullscreen_loading_page.dart';
import 'package:lk_client/service/http/authorization_service.dart';
import 'package:lk_client/state/authentication_state.dart';
import 'package:lk_client/store/app_state_container.dart';
import 'package:lk_client/widget/identify_form_widget.dart';
import 'package:lk_client/widget/login_form_widget.dart';
import 'package:lk_client/widget/register_form_widget.dart';

class PrivatePageSkeleton extends StatefulWidget {
  Widget page;
  AuthorizationService authorizationService;

  PrivatePageSkeleton(this.page, this.authorizationService);

  @override
  _PrivatePageSkeletonState createState() => _PrivatePageSkeletonState();
}

class _PrivatePageSkeletonState extends State<PrivatePageSkeleton> {
  Widget get page => widget.page;
  AuthorizationService get authorizationService => widget.authorizationService;

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
            
            return CenteredFormPageSkeleton(
                centeredForm: RegisterFormWidget(authorizationService)
            );

          } else if (state is AuthenticationUnauthorizedState) {

            return CenteredFormPageSkeleton(
                centeredForm: UserIdentifyFormWidget(authorizationService)
            );

          } else if (state is AuthenticationProcessingState || state is AuthenticationInvalidState) {

            return FullscreenLoadingPage();

          } else if (state is AuthenticationValidState) {

            return this.page;
            
          }

          return FullscreenLoadingPage();
        });
  }
}
