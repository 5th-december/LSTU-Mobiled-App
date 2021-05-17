import 'package:flutter/widgets.dart';
import 'package:lk_client/bloc/timetable_page_manager_bloc.dart';
import 'package:lk_client/store/global/app_state_container.dart';
import 'package:lk_client/store/global/service_provider.dart';

class TimetablePageProvider extends StatefulWidget {
  final Widget child;

  TimetablePageProvider({Key key, @required this.child}): super(key: key);

  @override
  State<TimetablePageProvider> createState() => TimetablePageProviderState();

  static TimetablePageProviderState of(BuildContext context) {
    TimetablePageProviderInherited inherited = context
        .dependOnInheritedWidgetOfExactType<TimetablePageProviderInherited>();
    return inherited.pageState;
  }
}

class TimetablePageProviderInherited extends InheritedWidget {
  final TimetablePageProviderState pageState;

  TimetablePageProviderInherited(
      {Key key, @required this.pageState, @required child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(TimetablePageProviderInherited old) => this.pageState != old.pageState;
}

class TimetablePageProviderState extends State<TimetablePageProvider> {
  TimetablePageManagerBloc timetablePageManagerBloc;

  void didChangeDependencies() {
    super.didChangeDependencies();
    if(this.timetablePageManagerBloc == null) {
      ServiceProvider appServiceProvider = AppStateContainer.of(context).serviceProvider;
      this.timetablePageManagerBloc = TimetablePageManagerBloc(educationQueryService: appServiceProvider.educationQueryService);
    }    
  }

  @override
  Widget build(BuildContext context) {
    return TimetablePageProviderInherited(
        pageState: this, child: widget.child);
  }
}