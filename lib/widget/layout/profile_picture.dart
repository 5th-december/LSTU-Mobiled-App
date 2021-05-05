import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/bloc/profile_picture_bloc.dart';
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

  PersonProfilePicture({@required this.displayed, @required this.size});

  _PersonProfilePictureState createState() => _PersonProfilePictureState();
}

class _PersonProfilePictureState extends State<PersonProfilePicture> {
  ProfilePictureBloc _profilePictureBloc;

  Person get _person => widget.displayed;
  double get _size => widget.size;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_profilePictureBloc == null) {
      PersonQueryService queryService =
          AppStateContainer.of(context).serviceProvider.personQueryService;
      this._profilePictureBloc = ProfilePictureBloc(queryService);
    }
  }

  @override
  dispose() async {
    Future.delayed(Duration.zero, () async {
      await this._profilePictureBloc.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    this._profilePictureBloc.eventController.sink.add(
        StartConsumeEvent<LoadProfilePicture>(
            request: LoadProfilePicture(this._person, this._size)));

    return StreamBuilder(
      stream: this._profilePictureBloc.loadProfilePictureStateStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData &&
            snapshot.data is ConsumingReadyState<ProfilePicture>) {
          var _state = snapshot.data as ConsumingReadyState<ProfilePicture>;
          ProfilePicture pic = _state.content;
          return Container(
              width: _size,
              height: _size,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      fit: BoxFit.fill, image: MemoryImage(pic.toBinary()))));
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
