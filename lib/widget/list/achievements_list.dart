import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/bloc/loader/loader_bloc.dart';
import 'package:lk_client/model/achievements/achievement.dart';
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/state/consuming_state.dart';
import 'package:lk_client/widget/chunk/centered_loader.dart';

class AchievementsList extends StatefulWidget {
  final Person person;
  final AchievementsListLoaderBloc achievementsListLoaderBloc;

  AchievementsList(
      {Key key,
      @required this.person,
      @required this.achievementsListLoaderBloc})
      : super(key: key);

  @override
  _AchievementsListState createState() => _AchievementsListState();
}

class _AchievementsListState extends State<AchievementsList> {
  AchievementsListLoaderBloc get _achievementsListLoaderBloc =>
      widget.achievementsListLoaderBloc;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: this._achievementsListLoaderBloc.consumingStateStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            ConsumingState<List<Achievement>> state = snapshot.data;

            if (state is ConsumingErrorState<List<Achievement>>) {
              return Center(
                  child: Text('Невозможно загрузить список публикаций'));
            }

            if (state is ConsumingReadyState<List<Achievement>>) {
              List<Achievement> loadedAchievements = state.content;

              if (loadedAchievements.length == 0) {
                return Center(child: Text('Пока нет записей'));
              }

              return ListView.separated(
                itemCount: loadedAchievements.length,
                itemBuilder: (BuildContext context, int index) {
                  Achievement achievement = loadedAchievements[index];
                  return Container(
                    child: ListTile(
                      title: Text(achievement.name),
                      subtitle: Text(achievement.kind),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    Divider(),
              );
            }
          }

          return CenteredLoader();
        });
  }
}
