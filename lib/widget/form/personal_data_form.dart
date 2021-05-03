import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/bloc/personal/personal_data_form_bloc.dart';
import 'package:lk_client/event/produce_command/user_produce_command.dart';
import 'package:lk_client/event/producing_event.dart';
import 'package:lk_client/model/person/personal_data.dart';
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/service/api_consumer/person_query_service.dart';
import 'package:lk_client/state/producing_state.dart';
import 'package:lk_client/store/app_state_container.dart';
import 'package:lk_client/widget/chunk/submit_loader_button.dart';

class PersonalDataForm extends StatefulWidget {
  final Person _editablePerson;

  PersonalDataForm(this._editablePerson);
  @override
  _PersonalDataFormState createState() => _PersonalDataFormState();
}

class _PersonalDataFormState extends State<PersonalDataForm> {
  PersonalDataFormBloc _personalDataFormBloc;

  final GlobalKey<FormState> _editFormKey = GlobalKey<FormState>();

  final _phoneEditingController = TextEditingController();
  final _emailEditionController = TextEditingController();
  final _messengerEditionController = TextEditingController();

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    if(this._personalDataFormBloc == null) {
      PersonQueryService service = AppStateContainer.of(context).serviceProvider.personQueryService;
      this._personalDataFormBloc = PersonalDataFormBloc(service);
    }
  }

  @override
  Widget build(BuildContext context) {
    this._personalDataFormBloc.eventController.sink.add(ProducerInitEvent<PersonalData>(resource: PersonalData.fromPerson(widget._editablePerson)));
    return Container(
      child: StreamBuilder(
        stream: this._personalDataFormBloc.personalDataUpdateStateStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.hasData && snapshot.data is ProducingState<PersonalData>) {
            ProducingState<PersonalData> state = snapshot.data;

            if(state.data != null) {
              this._phoneEditingController.text = state.data?.phone;
              this._emailEditionController.text = state.data?.email;
              this._messengerEditionController.text = state.data?.messenger;
            }

            return Form(
              key: _editFormKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Телефон',
                      errorText: state is ProducingInvalidState<PersonalData> ? state.errorBox.getFirstForField('phone').message: null,
                    ),
                    controller: _phoneEditingController,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'E-mail',
                      errorText: state is ProducingInvalidState<PersonalData> ? state.errorBox.getFirstForField('email').message: null,
                    ),
                    controller: _emailEditionController,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Мессенджер',
                      errorText: state is ProducingInvalidState<PersonalData> ? state.errorBox.getFirstForField('messenger').message: null,
                    ),
                    controller: _messengerEditionController,
                  ),
                  constructSubmitButton(state)
                ],
              ),
            );

          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      )
    );
  }

  Widget constructSubmitButton(ProducingState<PersonalData> state) {
    if(state is ProducingLoadingState<PersonalData>) {
      return SubmitLoaderButton(text: 'Сохранить', isLoading: true, onPressed: () {});
    }

    PersonalData personalData = PersonalData(
      email: this._emailEditionController.text, 
      phone: this._phoneEditingController.text, 
      messenger: this._messengerEditionController.text
    );

    return SubmitLoaderButton(text: 'Сохранить', isLoading: false, onPressed: () {
      this._personalDataFormBloc.eventController.sink.add(
        ProduceResourceEvent<PersonalData, UpdateProfileInformation>(command: UpdateProfileInformation(), resource: personalData));
    });
  }
}
