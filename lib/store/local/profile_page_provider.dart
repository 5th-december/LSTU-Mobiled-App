import 'package:flutter/widgets.dart';
import 'package:lk_client/bloc/loader_bloc.dart';
import 'package:lk_client/bloc/personal_data_form_bloc.dart';
import 'package:lk_client/store/global/app_state_container.dart';
import 'package:lk_client/store/global/service_provider.dart';

class ProfilePageProvider extends StatefulWidget
{
  final Widget child;

  ProfilePageProvider({Key key, @required this.child}): super(key: key);

  @override
  State<ProfilePageProvider> createState() => ProfilePageProviderState();
}

class ProfilePageInherited extends InheritedWidget 
{
  final ProfilePageProviderState pageState;

  ProfilePageInherited({Key key, @required this.pageState, @required child}): super(key: key, child: child);

  @override
  bool updateShouldNotify(ProfilePageInherited old) => this.pageState != old.pageState;
}

class ProfilePageProviderState extends State<ProfilePageProvider>
{
  PersonalDataFormBloc personalDataFormBloc;
  PersonalDetailsLoaderBloc personalDetailsLoaderBloc;

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    ServiceProvider appServiceProviser = AppStateContainer.of(context).serviceProvider;
    if(this.personalDetailsLoaderBloc == null) {
      this.personalDetailsLoaderBloc = PersonalDetailsLoaderBloc(appServiceProviser.personQueryService);
    }
    if(this.personalDataFormBloc == null) {
      this.personalDataFormBloc = PersonalDataFormBloc(appServiceProviser.personQueryService);
    }
    
  }
  @override
  Widget build(BuildContext context) {
    return ProfilePageInherited(child: widget.child, pageState: this);
  }
}