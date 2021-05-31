import 'package:flutter/widgets.dart';
import 'package:lk_client/bloc/dialog_creator_bloc.dart';
import 'package:lk_client/bloc/infinite_scrollers/person_list_bloc.dart';
import 'package:lk_client/store/global/app_state_container.dart';
import 'package:lk_client/store/global/service_provider.dart';

class PersonFinderPageProvider extends StatefulWidget {
  final Widget child;

  PersonFinderPageProvider({Key key, @required this.child}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PersonFinderPageProviderState();

  static PersonFinderPageProviderState of(BuildContext context) {
    PersonFinderPageInherited inherited =
        context.dependOnInheritedWidgetOfExactType<PersonFinderPageInherited>();
    return inherited.pageState;
  }
}

class PersonFinderPageInherited extends InheritedWidget {
  final PersonFinderPageProviderState pageState;

  PersonFinderPageInherited(
      {Key key, @required this.pageState, @required child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(PersonFinderPageInherited old) =>
      this.pageState != old.pageState;
}

class PersonFinderPageProviderState extends State<PersonFinderPageProvider> {
  PersonListBloc personListBloc;
  DialogCreatorBloc dialogCreatorBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ServiceProvider serviceProvider =
        AppStateContainer.of(context).serviceProvider;
    this.personListBloc =
        PersonListBloc(personQueryService: serviceProvider.personQueryService);
    this.dialogCreatorBloc = DialogCreatorBloc(
        messengerQueryService: serviceProvider.messengerQueryService);
  }

  @override
  Widget build(BuildContext context) {
    return PersonFinderPageInherited(child: widget.child, pageState: this);
  }
}
