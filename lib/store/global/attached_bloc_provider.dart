import 'package:lk_client/bloc/attached/abstract_attached_transport_bloc.dart';

class AttachedBlocProvider {
  Map<String, AbstractAttachedTransportBloc> _attachedBlocStorage =
      <String, AbstractAttachedTransportBloc>{};

  AbstractAttachedTransportBloc getAttachedTransportBloc(String key) {
    if (this._attachedBlocStorage.containsKey(key)) {
      return this._attachedBlocStorage[key];
    } else {
      return null;
    }
  }
}
