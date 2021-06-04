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
  MbCChatUpdateBlocContainer _mbCChatUpdateBlocContainer;

  ServiceProvider appServiceProvider;

  Future<MbCChatUpdateBlocContainer> mbCChatUpdateBlocContainer() async {
    if (this._mbCChatUpdateBlocContainer == null) {
      this._mbCChatUpdateBlocContainer = await MbCChatUpdateBlocContainer.init(
          this.appServiceProvider.utilQueryService,
          this.appServiceProvider.amqpConfig,
          this.appServiceProvider.amqpService);
    }
    return this._mbCChatUpdateBlocContainer;
  }

  MbCDialogListBlocContainer _mbCDialogListBlocContainer;

  Future<MbCDialogListBlocContainer> mbCDialogListBlocContainer() async {
    if (this._mbCDialogListBlocContainer == null) {
      this._mbCDialogListBlocContainer = await MbCDialogListBlocContainer.init(
          this.appServiceProvider.utilQueryService,
          this.appServiceProvider.amqpConfig,
          this.appServiceProvider.amqpService);
    }
    return this._mbCDialogListBlocContainer;
  }

  MbCDiscussionMessageBlocContainer _mbCDiscussionMessageBlocContainer;

  Future<MbCDiscussionMessageBlocContainer>
      mbCDiscussionMessageBlocContainer() async {
    if (this._mbCDiscussionMessageBlocContainer == null) {
      this._mbCDiscussionMessageBlocContainer =
          await MbCDiscussionMessageBlocContainer.init(
              this.appServiceProvider.utilQueryService,
              this.appServiceProvider.amqpConfig,
              this.appServiceProvider.amqpService);
    }
    return this._mbCDiscussionMessageBlocContainer;
  }

  MbCPrivateMessageBlocContainer _mbCPrivateMessageBlocContainer;

  Future<MbCPrivateMessageBlocContainer>
      mbCPrivateMessageBlocContainer() async {
    if (this._mbCPrivateMessageBlocContainer == null) {
      this._mbCPrivateMessageBlocContainer =
          await MbCPrivateMessageBlocContainer.init(
              this.appServiceProvider.utilQueryService,
              this.appServiceProvider.amqpConfig,
              this.appServiceProvider.amqpService);
    }
    return this._mbCPrivateMessageBlocContainer;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this.appServiceProvider = AppStateContainer.of(context).serviceProvider;
  }

  @override
  Widget build(BuildContext context) {
    return MbCBlocProviderInherited(
      child: widget.child,
      state: this,
    );
  }
}
