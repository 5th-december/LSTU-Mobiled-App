import 'package:flutter/widgets.dart';
import 'package:lk_client/bloc/infinite_scrollers/dialog_list_bloc.dart';
import 'package:lk_client/bloc/loader/loader_bloc.dart';
import 'package:lk_client/bloc/proxy/dialog_list_proxy_bloc.dart';
import 'package:lk_client/bloc_container/mbc_dialog_list_bloc_container.dart';
import 'package:lk_client/store/global/app_state_container.dart';
import 'package:lk_client/store/global/mbc_bloc_provider.dart';

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
  Future<DialogListProxyBloc> dialogListBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (this.dialogListBloc == null) {
      final appServiceProvider = AppStateContainer.of(context).serviceProvider;

      final dialogListLoadingBloc =
          DialogListLoadingBloc(appServiceProvider.messengerQueryService);

      final dialogInfiniteListBloc = DialogListBloc(dialogListLoadingBloc);

      final Future<MbCDialogListBlocContainer> mbcDialogListBlocContainer =
          MbCBlocProvider.of(context).mbCDialogListBlocContainer();

      this.dialogListBloc = DialogListProxyBloc.init(
          dialogListBloc: dialogInfiniteListBloc,
          mbCDialogListBlocContainer: mbcDialogListBlocContainer);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MessengerPageInherited(child: widget.child, pageState: this);
  }
}
