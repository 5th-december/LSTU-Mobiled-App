import 'dart:convert';
import 'dart:ffi';

import 'package:lk_client/model/entity/education_entity.dart';
import 'package:lk_client/model/entity/semester_entity.dart';
import 'package:lk_client/model/entity/subject_entity.dart';
import 'package:lk_client/model/error/component_error_handler.dart';
import 'package:lk_client/model/response/api_key.dart';
import 'package:lk_client/service/app_config.dart';
import 'package:lk_client/service/authentication_extractor.dart';
import 'package:lk_client/service/http/http_service.dart';

class EducationQueryService extends HttpService {
  final ComponentErrorHandler apiErrorHandler;
  final AuthenticationExtractor authenticationExtractor;

  ApiKey get accessKey => authenticationExtractor.getAuthenticationData();

  EducationQueryService(AppConfig configurator, this.authenticationExtractor,
      this.apiErrorHandler)
      : super(configurator);

  Future<List<EducationEntity>> getEducationsList(String person) async {
    HttpResponse response = await this.get('/api/v1/student/edu/list',
        <String, String>{'person': person}, this.accessKey.token);

    if (response.status == 200) {
      List<EducationEntity> educations = [];
      List<dynamic> educationValues = response.body as List<dynamic>;
      for (var education in educationValues) {
        educations.add(EducationEntity.fromJson(education));
      }
      return educations;
    }

    throw this.apiErrorHandler.apply(response.body);
  }

  Future<List<SemesterEntity>> getSemesterList(String educationId) async {
    HttpResponse response = await this.get('/api/v1/student/edu/semesters',
        <String, String>{'edu': educationId}, this.accessKey.token);

    if (response.status == 200) {
      List<SemesterEntity> semesters = [];

      List<dynamic> semestersData = response.body as List<dynamic>;

      for (var semesterData in semestersData) {
        semesters.add(SemesterEntity.fromJson(semesterData));
      }

      return semesters;
    }

    throw this.apiErrorHandler.apply(response.body);
  }

  Future<List<SubjectEntity>> getSubjectList(String educationId, String semesterId) async {
    HttpResponse response = await this.get('/api/v1/student/subject/list', 
        <String, String>{'edu': educationId, 'sem': semesterId});

    if(response.status == 200) {
      List<SubjectEntity> subjects = [];

      List<dynamic> subjectsData = response.body as List<dynamic>;

      for(var subjectData in subjectsData) {
        subjects.add(SubjectEntity.fromJson(subjectData));
      } 

      return subjects;
    }

    throw this.apiErrorHandler.apply(response.body);
  }
}
