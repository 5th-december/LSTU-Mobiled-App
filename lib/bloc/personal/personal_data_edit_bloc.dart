import 'package:lk_client/bloc/abstract_bloc.dart';
import 'package:lk_client/event/produce_command/user_produce_command.dart';
import 'package:lk_client/event/producing_event.dart';
import 'package:lk_client/model/person/contacts.dart';
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/model/validatable.dart';
import 'package:lk_client/service/api_consumer/person_query_service.dart';
import 'package:lk_client/state/producing_state.dart';

class PersonalDataEditBloc
    extends AbstractBloc<ProducingState, ProducingEvent> {
  Stream<ProducingEvent> get _personalContactsEditEventStream =>
      this.eventController.stream.where((event) =>
          event is ProduceResourceEvent<Contacts, UploadUserContacts>);

  Stream<ProducingEvent> get _personalContactsInitEventStram => this
      .eventController
      .stream
      .where((event) => event is ProducerInitEvent<Person, InitCommand>);

  Stream<ProducingState> get personalContactsEditStateStream => this
      .stateContoller
      .stream
      .where((event) => event is ProducingState<Person>);

  PersonalDataEditBloc(PersonQueryService queryService) {
    this._personalContactsInitEventStram.listen((event) {
      var _event = event as ProducerInitEvent<Person, InitCommand>;
      this.updateState(ProducingInitState<Person>(initData: _event.resource));
    });

    this._personalContactsEditEventStream.listen((event) {
      var _event = event as ProduceResourceEvent<Contacts, UploadUserContacts>;
      Contacts editedContacts = _event.resource;

      ValidationErrorBox validationErrors = editedContacts.validate();
      if (validationErrors.hasErrors()) {
        this.updateState(ProducingInvalidState<Person>(validationErrors));
        return;
      }

      try {
        queryService.editPersonProfile(editedContacts);
      } ca
    });
  }
}
