import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/bloc/loader_bloc.dart';
import 'package:lk_client/command/consume_command/user_request_command.dart';
import 'package:lk_client/event/consuming_event.dart';
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/model/person/profile_picture.dart';
import 'package:lk_client/service/api_consumer/person_query_service.dart';
import 'package:lk_client/state/consuming_state.dart';
import 'package:lk_client/store/global/app_state_container.dart';

class PersonProfilePicture extends StatefulWidget {
  final Person displayed;
  final double size;

  PersonProfilePicture({Key key, @required this.displayed, @required this.size}): super(key: key);

  _PersonProfilePictureState createState() => _PersonProfilePictureState();
}

class _PersonProfilePictureState extends State<PersonProfilePicture> {
  ProfilePictureLoaderBloc _bloc;

  Person get _person => widget.displayed;
  double get _size => widget.size;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (this._bloc == null) {
      PersonQueryService queryService =
          AppStateContainer.of(context).serviceProvider.personQueryService;
      this._bloc = ProfilePictureLoaderBloc(queryService);
    }
  }

  @override
  dispose() async {
    Future.delayed(Duration.zero, () async {
      await this._bloc.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    this._bloc.eventController.sink.add(
        StartConsumeEvent<LoadProfilePicture>(
            request: LoadProfilePicture(this._person, this._size)));

    return StreamBuilder(
      stream: this._bloc.consumingStateStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData &&
            snapshot.data is ConsumingReadyState<ProfilePicture>) {
          var _state = snapshot.data as ConsumingReadyState<ProfilePicture>;
          ProfilePicture pic = _state.content;
          return SizedBox(
              width: _size,
              height: _size,
              child: Container (
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      fit: BoxFit.fill, image: MemoryImage(pic.toBinary())))));
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
