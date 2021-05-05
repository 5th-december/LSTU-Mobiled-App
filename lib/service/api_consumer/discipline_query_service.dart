import 'package:flutter/foundation.dart';
import 'package:lk_client/model/discipline/discipline.dart';
import 'package:lk_client/error_handler/component_error_handler.dart';
import 'package:lk_client/model/authentication/api_key.dart';
import 'package:lk_client/model/education/timetable.dart';
import 'package:lk_client/model/education/timetable_item.dart';
import 'package:lk_client/model/listed_response.dart';
import 'package:lk_client/service/app_config.dart';
import 'package:lk_client/service/authentication_extractor.dart';
import 'package:lk_client/service/http_service.dart';
import 'package:lk_client/state/consuming_state.dart';

class DisciplineQueryService extends HttpService {
  final ComponentErrorHandler apiErrorHandler;

  final AuthenticationExtractor authenticationExtractor;

  ApiKey get accessKey => this.authenticationExtractor.getAuthenticationData();

  DisciplineQueryService(
      {@required AppConfig appConfig,
      @required this.apiErrorHandler,
      @required this.authenticationExtractor})
      : super(appConfig);

  Stream<ConsumingState<Discipline>> getDisciplineItem(
      String discipline) async* {
    try {
      HttpResponse response = await this.get('/api/v1/student/discipline',
          <String, String>{'dis': discipline}, this.accessKey.token);

      if (response.status == 200) {
        Discipline discipline = Discipline.fromJson(response.body);
        yield ConsumingReadyState<Discipline>(discipline);
      } else {
        throw this.apiErrorHandler.apply(response.body);
      }
    } on Exception catch (e) {
      yield ConsumingErrorState<Discipline>(error: e);
    }
  }

  Stream<ConsumingState<ListedResponse<TimetableItem>>> getDisciplineTeachers(
      String discipline, String education, String semester) async* {
    try {
      HttpResponse response = await this.get(
          '/api/v1/student/discipline/teachers',
          <String, String>{
            'dis': discipline,
            'edu': education,
            'sem': semester
          },
          this.accessKey.token);

      if (response.status == 200) {
        ListedResponse<TimetableItem> disciplineTeachersList =
            ListedResponse.fromJson(response.body, TimetableItem.fromJson);
        yield ConsumingReadyState<ListedResponse<TimetableItem>>(
            disciplineTeachersList);
      } else {
        throw this.apiErrorHandler.apply(response.body);
      }
    } on Exception catch (e) {
      yield ConsumingErrorState<ListedResponse<TimetableItem>>(error: e);
    }
  }

  Stream<ConsumingState<Timetable>> getDisciplineTimetable(String discipline, String education, String semester) async* {
    try {
      HttpResponse response = await this.get(
        '/api/v1/student/discipline/timetable', 
        <String, String> {
          'dis': discipline,
          'edu': education,
          'sem': semester
        },
        this.accessKey.token
      );

      if(response.status == 200) {
        Timetable timetable = Timetable.fromJson(response.body);
        yield ConsumingReadyState<Timetable>(timetable);
      } else {
        throw this.apiErrorHandler.apply(response.body);
      }
    } on Exception catch(e) {
      yield ConsumingErrorState<Timetable>(error: e);
    }
  }
}
