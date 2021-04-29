import 'package:lk_client/model/discipline/discipline.dart';
import 'package:lk_client/error_handler/component_error_handler.dart';
import 'package:lk_client/model/authentication/api_key.dart';
import 'package:lk_client/model/education/timetable.dart';
import 'package:lk_client/model/education/timetable_item.dart';
import 'package:lk_client/model/listed_response.dart';
import 'package:lk_client/service/app_config.dart';
import 'package:lk_client/service/authentication_extractor.dart';
import 'package:lk_client/service/http/http_service.dart';

class DisciplineQueryService extends HttpService
{
  final ComponentErrorHandler apiErrorHandler;

  final AuthenticationExtractor authenticationExtractor;

  ApiKey get accessKey => this.authenticationExtractor.getAuthenticationData(); 

  DisciplineQueryService(AppConfig appConfig, this.apiErrorHandler, this.authenticationExtractor):
    super(appConfig);

  Stream<Discipline> getDisciplineItem(String discipline) async* 
  {
    HttpResponse response = await this.get(
      '/api/v1/student/discipline/', 
      <String, String>{
        'dis': discipline
      }, 
      this.accessKey.token
    );

    if(response.status == 200) {
      Discipline discipline = Discipline.fromJson(response.body);
      yield discipline;
    } else {
      throw this.apiErrorHandler.apply(response.body);
    }
  }

  Stream<ListedResponse<TimetableItem>> getDisciplineTeachers(String discipline, String education, String semester) async* 
  {
    HttpResponse response = await this.get(
      '/api/v1/student/discipline/teachers', 
      <String, String> {
        'dis': discipline, 
        'edu': education, 
        'sem': semester
      }, 
      this.accessKey.token
    );

    if(response.status == 200) {
      ListedResponse<TimetableItem> disciplineTeachersList = ListedResponse.fromJson(response.body, TimetableItem.fromJson);
      yield disciplineTeachersList;
    } else {
      throw this.apiErrorHandler.apply(response.body);
    }
  }

  Stream<Timetable> getDisciplineTimetable(String discipline, String education, String semester) async* 
  {
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
      Timetable selectedDisciplineTimetable = Timetable.fromJson(response.body);
      yield selectedDisciplineTimetable;
    } else {
      throw this.apiErrorHandler.apply(response.body);
    }
  }
}