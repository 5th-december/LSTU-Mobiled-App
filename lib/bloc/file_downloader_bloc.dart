import 'package:lk_client/bloc/abstract_bloc.dart';
import 'package:lk_client/event/file_management_event.dart';
import 'package:lk_client/state/file_management_state.dart';

class FileDownloaderBloc
    extends AbstractBloc<FileManagementState, FileManagementEvent> {
  Stream<FileManagementState> get downloaderStateStream =>
      this.stateContoller.stream.where((event) => event is FileManagementState);

  Stream<FileManagementEvent> get _downloaderEventStream => this
      .eventController
      .stream
      .where((event) => event is FileManagementEvent);

  FileDownloaderBloc();
}
