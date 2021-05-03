import 'package:lk_client/state/content_state.dart';

class SelectSingleDefaultFromList<T> extends ContentState<T>
{
  final T selected;
  SelectSingleDefaultFromList({this.selected});
}