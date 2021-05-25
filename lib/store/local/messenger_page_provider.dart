import 'package:flutter/cupertino.dart';
import 'package:lk_client/bloc/infinite_scrollers/dialog_list_bloc.dart';
import 'package:lk_client/bloc/loader/loader_bloc.dart';
import 'package:lk_client/store/global/app_state_container.dart';
import 'package:lk_client/store/global/service_provider.dart';

class MessengerPageProvider extends StatefulWidget {
  final Widget child;

  MessengerPageProvider({Key key, @required this.child}) : super(key: key);

  State<MessengerPageProvider> createState() => MessengerPageProviderState();

  static MessengerPageProviderState of(BuildContext context) {
    MessengerPageInherited inherited =
        context.dependOnInheritedWidgetOfExactType<MessengerPageInherited>();
    return inherited.pageState;
  }
}

class MessengerPageInherited extends InheritedWidget {
  final MessengerPageProviderState pageState;

  MessengerPageInherited({Key key, @required this.pageState, @required child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(MessengerPageInherited old) =>
      this.pageState != old.pageState;
}

class MessengerPageProviderState extends State<MessengerPageProvider> {
  DialogListBloc dialogListBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (this.dialogListBloc == null) {
      ServiceProvider appServiceProvider =
          AppStateContainer.of(context).serviceProvider;
      DialogListLoadingBloc dialogListLoadingBloc =
          DialogListLoadingBloc(appServiceProvider.messengerQueryService);
      this.dialogListBloc = DialogListBloc(dialogListLoadingBloc);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MessengerPageInherited(child: widget.child, pageState: this);
  }
}
