import 'package:lk_client/model/education/education.dart';
import 'package:lk_client/model/education/exam.dart';
import 'package:lk_client/model/education/semester.dart';
import 'package:lk_client/model/discipline/discipline.dart';
import 'package:lk_client/error_handler/component_error_handler.dart';
import 'package:lk_client/model/authentication/api_key.dart';
import 'package:lk_client/model/education/timetable.dart';
import 'package:lk_client/model/listed_response.dart';
import 'package:lk_client/service/config/app_config.dart';
import 'package:lk_client/service/authentication_extractor.dart';
import 'package:lk_client/service/http_service.dart';
import 'package:lk_client/state/consuming_state.dart';

class EducationQueryService {
  final ComponentErrorHandler apiErrorHandler;
  final AuthenticationExtractor authenticationExtractor;
  final ApiEndpointConsumer apiEndpointConsumer;

  EducationQueryService(this.apiEndpointConsumer, this.authenticationExtractor,
      this.apiErrorHandler);

  Stream<ConsumingState<ListedResponse<Education>>> getEducationsList(
      String person) async* {
    try {
      HttpResponse response = await this.apiEndpointConsumer.get(
          '/api/v1/student/edu/list',
          <String, String>{'p': person},
          await this.authenticationExtractor.getAuthenticationData);

      if (response.status == 200) {
        ListedResponse<Education> personEducationsList =
            ListedResponse.fromJson(response.body, Education.fromJson);
        yield ConsumingReadyState<ListedResponse<Education>>(
            personEducationsList);
      } else {
        throw this.apiErrorHandler.apply(response.body);
      }
    } on Exception catch (e) {
      yield ConsumingErrorState<ListedResponse<Education>>(error: e);
    }
  }

  Stream<ConsumingState<ListedResponse<Semester>>> getSemesterList(
      String educationId) async* {
    try {
      HttpResponse response = await this.apiEndpointConsumer.get(
          '/api/v1/student/edu/semesters/list',
          <String, String>{'edu': educationId},
          await this.authenticationExtractor.getAuthenticationData);

      if (response.status == 200) {
        ListedResponse<Semester> personSemesterList =
            ListedResponse.fromJson(response.body, Semester.fromJson);
        yield ConsumingReadyState<ListedResponse<Semester>>(personSemesterList);
      } else {
        throw this.apiErrorHandler.apply(response.body);
      }
    } on Exception catch (e) {
      yield ConsumingErrorState<ListedResponse<Semester>>(error: e);
    }
  }

  Stream<ConsumingState<ListedResponse<Discipline>>> getSubjectList(
      String educationId, String semesterId) async* {
    try {
      HttpResponse response = await this.apiEndpointConsumer.get(
          '/api/v1/student/discipline/list',
          <String, String>{'edu': educationId, 'sem': semesterId},
          await this.authenticationExtractor.getAuthenticationData);

      if (response.status == 200) {
        ListedResponse<Discipline> requiredDisciplineList =
            ListedResponse.fromJson(response.body, Discipline.fromJson);
        yield ConsumingReadyState<ListedResponse<Discipline>>(
            requiredDisciplineList);
      } else {
        throw this.apiErrorHandler.apply(response.body);
      }
    } on Exception catch (e) {
      yield ConsumingErrorState<ListedResponse<Discipline>>(error: e);
    }
  }

  Stream<ConsumingState<Semester>> getCurrentSemester(
      String educationId) async* {
    try {
      HttpResponse response = await this.apiEndpointConsumer.get(
          '/api/v1/student/edu/semesters/current',
          <String, String>{'edu': educationId},
          await this.authenticationExtractor.getAuthenticationData);

      if (response.status == 200) {
        Semester currentSemester = Semester.fromJson(response.body);
        yield ConsumingReadyState<Semester>(currentSemester);
      } else {
        throw this.apiErrorHandler.apply(response.body);
      }
    } on Exception catch (e) {
      yield ConsumingErrorState<Semester>(error: e);
    }
  }

  Stream<ConsumingState<Timetable>> getCurrentTimetable(
      String educationId, String semesterId, String weekType) async* {
    try {
      HttpResponse response = await this.apiEndpointConsumer.get(
          '/api/v1/student/timetable',
          <String, String>{
            'edu': educationId,
            'sem': semesterId,
            'week': weekType
          },
          await this.authenticationExtractor.getAuthenticationData);

      if (response.status == 200) {
        Timetable loadedTimetable = Timetable.fromJson(response.body);
        yield ConsumingReadyState<Timetable>(loadedTimetable);
      } else {
        yield ConsumingErrorState<Timetable>(
            error: this.apiErrorHandler.apply(response.body));
      }
    } on Exception catch (e) {
      yield ConsumingErrorState<Timetable>(error: e);
    }
  }

  Stream<ConsumingState<ListedResponse<Exam>>> getExamsTimetable(
      String educationId, String semesterId) async* {
    try {
      HttpResponse response = await this.apiEndpointConsumer.get(
          '/api/v1/student/timetable/exams/list',
          <String, String>{'edu': educationId, 'sem': semesterId},
          await this.authenticationExtractor.getAuthenticationData);

      if (response.status == 200) {
        ListedResponse<Exam> loadedExamsList =
            ListedResponse.fromJson(response.body, Exam.fromJson);
        yield ConsumingReadyState<ListedResponse<Exam>>(loadedExamsList);
      } else {
        yield ConsumingErrorState<ListedResponse<Exam>>(
            error: this.apiErrorHandler.apply(response.body));
      }
    } on Exception catch (e) {
      yield ConsumingErrorState<ListedResponse<Exam>>(error: e);
    }
  }
}
