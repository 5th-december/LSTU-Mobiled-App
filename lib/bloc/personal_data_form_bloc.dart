import 'package:lk_client/bloc/abstract_bloc.dart';
import 'package:lk_client/command/produce_command/user_produce_command.dart';
import 'package:lk_client/error_handler/validation_error_handler.dart';
import 'package:lk_client/event/producing_event.dart';
import 'package:lk_client/model/person/personal_data.dart';
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/model/validatable.dart';
import 'package:lk_client/service/api_consumer/person_query_service.dart';
import 'package:lk_client/state/producing_state.dart';

class PersonalDataFormBloc
    extends AbstractBloc<ProducingState, ProducingEvent> {
  Stream<ProducingEvent> get _personalDataUpdateEventStream =>
      this.eventController.stream.where((event) => event
          is ProduceResourceEvent<PersonalData, UpdateProfileInformation>);

  Stream<ProducingEvent> get _personalDataInitEventStram => this
      .eventController
      .stream
      .where((event) => event is ProducerInitEvent<PersonalData>);

  Stream<ProducingState> get personalDataUpdateStateStream => this
      .stateContoller
      .stream
      .where((event) => event is ProducingState<PersonalData>);

  PersonalDataFormBloc(PersonQueryService queryService) {
    this._personalDataInitEventStram.listen((event) {
      var _event = event as ProducerInitEvent<PersonalData>;
      this.updateState(
          ProducingInitState<PersonalData>(initData: _event.resourse));
    });

    this._personalDataUpdateEventStream.listen((event) async {
      var _event =
          event as ProduceResourceEvent<PersonalData, UpdateProfileInformation>;
      PersonalData profileEditionData = _event.resourse;

      this.updateState(
          ProducingLoadingState<PersonalData>(data: profileEditionData));

      ValidationErrorBox validationErrors = profileEditionData.validate();
      if (validationErrors.hasErrors()) {
        this.updateState(ProducingInvalidState<PersonalData>(validationErrors));
        return;
      }

      try {
        bool updated = await queryService.editPersonProfile(profileEditionData);
        this.updateState(ProducingReadyState<PersonalData, bool>(
            data: profileEditionData, response: updated));
      } on ValidationException catch (e) {
        this.updateState(ProducingInvalidState<PersonalData>(null,
            data: profileEditionData)); // TODO: Add server validation errors
        return;
      } on Exception catch (e) {
        this.updateState(
            ProducingErrorState<PersonalData>(e, data: profileEditionData));
      }
    });
  }
}


