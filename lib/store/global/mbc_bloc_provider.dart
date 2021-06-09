import 'package:flutter/widgets.dart';
import 'package:lk_client/bloc_container/mbc_chat_update_bloc_container.dart';
import 'package:lk_client/bloc_container/mbc_dialog_list_bloc_container.dart';
import 'package:lk_client/bloc_container/mbc_discussion_message_bloc_container.dart';
import 'package:lk_client/bloc_container/mbc_private_message_bloc_container.dart';
import 'package:lk_client/store/global/app_state_container.dart';
import 'package:lk_client/store/global/service_provider.dart';

class MbCBlocProvider extends StatefulWidget {
  final Widget child;

  MbCBlocProvider({Key key, @required this.child}) : super(key: key);

  @override
  State<MbCBlocProvider> createState() => MbCBlocProviderState();

  static MbCBlocProviderState of(BuildContext context) {
    MbCBlocProviderInherited inherited =
        context.dependOnInheritedWidgetOfExactType<MbCBlocProviderInherited>();
    return inherited.state;
  }
}

class MbCBlocProviderInherited extends InheritedWidget {
  final MbCBlocProviderState state;

  MbCBlocProviderInherited({Key key, @required this.state, @required child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(MbCBlocProviderInherited old) => false;
}

class MbCBlocProviderState extends State<MbCBlocProvider> {
  ServiceProvider appServiceProvider;

  Future<MbCChatUpdateBlocContainer> _mbCChatUpdateBlocContainer;

  Future<MbCChatUpdateBlocContainer> mbCChatUpdateBlocContainer() async {
    return this._mbCChatUpdateBlocContainer;
  }

  Future<MbCDialogListBlocContainer> _mbCDialogListBlocContainer;

  Future<MbCDialogListBlocContainer> mbCDialogListBlocContainer() async {
    return this._mbCDialogListBlocContainer;
  }

  Future<MbCDiscussionMessageBlocContainer> _mbCDiscussionMessageBlocContainer;

  Future<MbCDiscussionMessageBlocContainer>
      mbCDiscussionMessageBlocContainer() async {
    return this._mbCDiscussionMessageBlocContainer;
  }

  Future<MbCPrivateMessageBlocContainer> _mbCPrivateMessageBlocContainer;

  Future<MbCPrivateMessageBlocContainer>
      mbCPrivateMessageBlocContainer() async {
    return this._mbCPrivateMessageBlocContainer;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this.appServiceProvider = AppStateContainer.of(context).serviceProvider;

    this._mbCChatUpdateBlocContainer = MbCChatUpdateBlocContainer.init(
        this.appServiceProvider.utilQueryService,
        this.appServiceProvider.amqpConfig,
        this.appServiceProvider.amqpService);

    this._mbCDialogListBlocContainer = MbCDialogListBlocContainer.init(
        this.appServiceProvider.utilQueryService,
        this.appServiceProvider.amqpConfig,
        this.appServiceProvider.amqpService);

    this._mbCDiscussionMessageBlocContainer =
        MbCDiscussionMessageBlocContainer.init(
            this.appServiceProvider.utilQueryService,
            this.appServiceProvider.amqpConfig,
            this.appServiceProvider.amqpService);

    this._mbCPrivateMessageBlocContainer = MbCPrivateMessageBlocContainer.init(
        this.appServiceProvider.utilQueryService,
        this.appServiceProvider.amqpConfig,
        this.appServiceProvider.amqpService);
  }

  @override
  Widget build(BuildContext context) {
    return MbCBlocProviderInherited(
      child: widget.child,
      state: this,
    );
  }
}
