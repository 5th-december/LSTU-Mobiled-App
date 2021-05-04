import 'package:lk_client/bloc/abstract_bloc.dart';
import 'package:lk_client/command/consume_command/user_request_command.dart';
import 'package:lk_client/event/content_event.dart';
import 'package:lk_client/model/person/profile_picture.dart';
import 'package:lk_client/service/api_consumer/person_query_service.dart';
import 'package:lk_client/state/content_state.dart';

class ProfilePictureBloc extends AbstractBloc<ContentState, ContentEvent> {
  Stream<ContentEvent> get _loadProfilePictureEventStream => this
      .eventController
      .stream
      .where((event) => event is StartLoadingContentEvent<LoadProfilePicture>);

  Stream<ContentState> get loadProfilePictureStateStream => this
      .stateContoller
      .stream
      .where((event) => event is ContentState<ProfilePicture>);

  ProfilePictureBloc(PersonQueryService personQueryService) {
    this._loadProfilePictureEventStream.listen((event) {
      var _event = event as StartLoadingContentEvent<LoadProfilePicture>;
      LoadProfilePicture command = _event.request;

      this.updateState(ContentLoadingState<ProfilePicture>());

      String sizeLiteral = 'sm';
      if (command.size > 150 && command.size <= 400) {
        sizeLiteral = 'md';
      } else if (command.size > 400) {
        sizeLiteral = 'lg';
      }

      try {
        personQueryService
            .getPersonProfilePicture(command.person.id, sizeLiteral)
            .listen((event) {
          this.updateState(ContentReadyState<ProfilePicture>(event));
        });
      } on Exception catch (e) {
        this.updateState(ContentErrorState<ProfilePicture>(e));
      }
    });
  }
}
