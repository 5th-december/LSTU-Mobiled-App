import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/bloc/loader/loader_bloc.dart';
import 'package:lk_client/model/achievements/publication.dart';
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/state/consuming_state.dart';
import 'package:lk_client/widget/chunk/centered_loader.dart';

class PublicationsList extends StatefulWidget {
  final Person person;
  final PublicationsListLoaderBloc publicationsListLoaderBloc;

  PublicationsList(
      {Key key,
      @required this.person,
      @required this.publicationsListLoaderBloc})
      : super(key: key);

  @override
  _PublicationsListState createState() => _PublicationsListState();
}

class _PublicationsListState extends State<PublicationsList> {
  PublicationsListLoaderBloc get _publicationsListLoaderBloc =>
      widget.publicationsListLoaderBloc;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: this._publicationsListLoaderBloc.consumingStateStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          ConsumingState<List<Publication>> state = snapshot.data;

          if (state is ConsumingErrorState<List<Publication>>) {
            return Center(
              child: Text('Невозможно загрузить список публикаций'),
            );
          }

          if (state is ConsumingReadyState<List<Publication>>) {
            List<Publication> loadedPublications = state.content;

            if (loadedPublications.length == 0) {
              return Center(child: Text('Пока нет публикаций'));
            }

            return ListView.separated(
              itemCount: loadedPublications.length,
              itemBuilder: (BuildContext context, int index) {
                Publication publication = loadedPublications[index];
                return Container(
                  child: ListTile(
                    title: Text(publication.title),
                    subtitle: Text(publication.description),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) => Divider(),
            );
          }
        }

        return CenteredLoader();
      },
    );
  }
}
