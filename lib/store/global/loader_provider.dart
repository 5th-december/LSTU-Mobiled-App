import 'package:flutter/cupertino.dart';
import 'package:lk_client/widget/chunk/file_download_widget.dart';

class LoaderProvider extends StatefulWidget {
  final Widget child;

  LoaderProvider({Key key, @required this.child}) : super(key: key);

  @override
  State<LoaderProvider> createState() => LoaderProviderState();

  static LoaderProviderState of(BuildContext context) {
    LoaderProviderInherited inherited =
        context.dependOnInheritedWidgetOfExactType<LoaderProviderInherited>();
    return inherited.state;
  }
}

class LoaderProviderInherited extends InheritedWidget {
  final LoaderProviderState state;

  LoaderProviderInherited({Key key, @required this.state, @required child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}

class LoaderProviderState extends State<LoaderProvider> {
  FileDownloaderBlocProvider fileDownloaderBlocProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this.fileDownloaderBlocProvider = FileDownloaderBlocProvider();
  }

  @override
  Widget build(BuildContext context) {
    return LoaderProviderInherited(child: widget.child, state: this);
  }
}
