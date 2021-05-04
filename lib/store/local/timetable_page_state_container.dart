import 'package:flutter/widgets.dart';
import 'package:lk_client/bloc/timetable_page_manager_bloc.dart';
import 'package:lk_client/store/global/app_state_container.dart';
import 'package:lk_client/store/global/service_provider.dart';

class TimetablePageStateContainer extends StatefulWidget {
  final Widget child;
  final ServiceProvider serviceProvider;

  TimetablePageStateContainer(
      {Key key, @required this.child, @required this.serviceProvider})
      : super(key: key);

  @override
  TimetablePageStateContainerState createState() =>
      TimetablePageStateContainerState(serviceProvider);

  static TimetablePageStateContainerState of(BuildContext context) {
    TimetablePageStateContainerInherited inherited = context
        .dependOnInheritedWidgetOfExactType<TimetablePageStateContainerInherited>();
    return inherited.state;
  }
}

class TimetablePageStateContainerInherited extends InheritedWidget {
  final TimetablePageStateContainerState state;

  TimetablePageStateContainerInherited(
      {Key key, @required this.state, @required child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(TimetablePageStateContainerInherited old) => true;
}

class TimetablePageStateContainerState
    extends State<TimetablePageStateContainer> {
  TimetablePageLocalBlocProvider localBlocProvider;

  TimetablePageStateContainerState(ServiceProvider global) {
    this.localBlocProvider = TimetablePageLocalBlocProvider(
        timetablePageManagerBloc: TimetablePageManagerBloc(
            educationQueryService:
                global.educationQueryService));
  }

  @override
  Widget build(BuildContext context) {
    return TimetablePageStateContainerInherited(
        state: this, child: widget.child);
  }
}

class TimetablePageLocalBlocProvider {
  final TimetablePageManagerBloc timetablePageManagerBloc;

  TimetablePageLocalBlocProvider({@required this.timetablePageManagerBloc});
}
