import 'package:flutter/cupertino.dart';

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
  @override
  Widget build(BuildContext context) {
    return MbCBlocProviderInherited(
      child: widget.child,
      state: this,
    );
  }
}
