import 'package:lk_client/bloc/abstract_bloc.dart';
import 'package:lk_client/command/consume_command/user_request_command.dart';
import 'package:lk_client/event/consuming_event.dart';
import 'package:lk_client/model/person/profile_picture.dart';
import 'package:lk_client/service/api_consumer/person_query_service.dart';
import 'package:lk_client/state/consuming_state.dart';

class ProfilePictureBloc extends AbstractBloc<ConsumingState, ConsumingEvent> {
  Stream<ConsumingEvent> get _loadProfilePictureEventStream => this
      .eventController
      .stream
      .where((event) => event is StartConsumeEvent<LoadProfilePicture>);

  Stream<ConsumingState> get loadProfilePictureStateStream => this
      .stateContoller
      .stream
      .where((event) => event is ConsumingState<ProfilePicture>);

  ProfilePictureBloc(PersonQueryService personQueryService) {
    this._loadProfilePictureEventStream.listen((event) {
      var _event = event as StartConsumeEvent<LoadProfilePicture>;
      LoadProfilePicture command = _event.request;

      this.updateState(ConsumingLoadingState<ProfilePicture>());

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
          this.updateState(ConsumingReadyState<ProfilePicture>(event));
        });
      } on Exception catch (e) {
        this.updateState(ConsumingErrorState<ProfilePicture>(error: e));
      }
    });
  }
}
