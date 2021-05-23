import 'package:flutter/widgets.dart';
import 'package:lk_client/bloc/attached/personal_data_form_bloc.dart';
import 'package:lk_client/bloc/loader/loader_bloc.dart';
import 'package:lk_client/store/global/app_state_container.dart';
import 'package:lk_client/store/global/service_provider.dart';

class ProfilePageProvider extends StatefulWidget {
  final Widget child;

  ProfilePageProvider({Key key, @required this.child}) : super(key: key);

  @override
  State<ProfilePageProvider> createState() => ProfilePageProviderState();

  static ProfilePageProviderState of(BuildContext context) {
    ProfilePageInherited inherited =
        context.dependOnInheritedWidgetOfExactType<ProfilePageInherited>();
    return inherited.pageState;
  }
}

class ProfilePageInherited extends InheritedWidget {
  final ProfilePageProviderState pageState;

  ProfilePageInherited({Key key, @required this.pageState, @required child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(ProfilePageInherited old) =>
      this.pageState != old.pageState;
}

class ProfilePageProviderState extends State<ProfilePageProvider> {
  PersonalDataFormBloc personalDataFormBloc;
  PersonalDetailsLoaderBloc personalDetailsLoaderBloc;
  PublicationsListLoaderBloc publicationsListLoaderBloc;
  AchievementsSummaryLoaderBloc achievementsSummaryLoaderBloc;
  AchievementsListLoaderBloc achievementsListLoaderBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ServiceProvider appServiceProvider =
        AppStateContainer.of(context).serviceProvider;
    if (this.personalDetailsLoaderBloc == null) {
      this.personalDetailsLoaderBloc =
          PersonalDetailsLoaderBloc(appServiceProvider.personQueryService);
    }
    if (this.personalDataFormBloc == null) {
      this.personalDataFormBloc =
          PersonalDataFormBloc(appServiceProvider.personQueryService);
    }
    if (this.publicationsListLoaderBloc == null) {
      this.publicationsListLoaderBloc = PublicationsListLoaderBloc(
          appServiceProvider.achievementQueryService);
    }
    if (this.achievementsListLoaderBloc == null) {
      this.achievementsListLoaderBloc = AchievementsListLoaderBloc(
          appServiceProvider.achievementQueryService);
    }
    if (this.achievementsSummaryLoaderBloc == null) {
      this.achievementsSummaryLoaderBloc = AchievementsSummaryLoaderBloc(
          appServiceProvider.achievementQueryService);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ProfilePageInherited(child: widget.child, pageState: this);
  }
}
