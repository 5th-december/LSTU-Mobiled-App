import 'package:flutter/widgets.dart';
import 'package:lk_client/bloc/attached/attached_private_message_form_bloc.dart';
import 'package:lk_client/bloc/attached/file_transfer_bloc.dart';
import 'package:lk_client/bloc/attached/private_message_form_bloc.dart';
import 'package:lk_client/bloc/infinite_scrollers/private_message_list_bloc.dart';
import 'package:lk_client/bloc/loader/loader_bloc.dart';
import 'package:lk_client/store/global/app_state_container.dart';
import 'package:lk_client/store/global/service_provider.dart';

class PrivateDialogPageProvider extends StatefulWidget
{
  final Widget child;

  PrivateDialogPageProvider({Key key, @required this.child}): super(key: key);

  @override
  State<PrivateDialogPageProvider> createState() => PrivateDialogPageProviderState();

  static PrivateDialogPageProviderState of(BuildContext context) {
    PrivateDialogPageInherited inherited = context
      .dependOnInheritedWidgetOfExactType<PrivateDialogPageInherited>();
    return inherited.pageState;
  }
}

class PrivateDialogPageInherited extends InheritedWidget
{
  PrivateDialogPageProviderState pageState;

  PrivateDialogPageInherited({Key key, @required this.pageState, @required child})
    :super(key: key, child: child);

  @override
  bool updateShouldNotify(PrivateDialogPageInherited old) => this.pageState != old.pageState;
}

class PrivateDialogPageProviderState extends State<PrivateDialogPageProvider>
{
  PrivateMessageListBloc privateMessageListBloc;
  AttachedPrivateMessageFormBloc attachedPrivateMessageFormBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ServiceProvider appServiceProvider = AppStateContainer.of(context).serviceProvider;
    if(this.privateMessageListBloc == null) {
      PrivateChatMessagesListLoadingBloc privateChatMessagesListLoadingBloc = 
        PrivateChatMessagesListLoadingBloc(appServiceProvider.messengerQueryService);
      this.privateMessageListBloc = PrivateMessageListBloc(privateChatMessagesListLoadingBloc);
    }

    if(this.attachedPrivateMessageFormBloc == null) {
      PrivateMessageSendDocumentTransferBloc privateMessageSendDocumentTransferBloc = 
        PrivateMessageSendDocumentTransferBloc(
          appServiceProvider.appConfig, 
          appServiceProvider.fileLocalManager, 
          appServiceProvider.fileTransferService);
      PrivateMessageFormBloc privateMessageFormBloc = 
        PrivateMessageFormBloc(messengerQueryService: appServiceProvider.messengerQueryService);
      this.attachedPrivateMessageFormBloc = AttachedPrivateMessageFormBloc(
        privateMessageDocumentTransferBloc: privateMessageSendDocumentTransferBloc,
        privateMessageFormBloc: privateMessageFormBloc
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return PrivateDialogPageInherited(pageState: this, child: widget.child);
  }
}