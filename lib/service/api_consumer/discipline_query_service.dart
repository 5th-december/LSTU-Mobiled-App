import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/model/discipline/discipline.dart';
import 'package:lk_client/error_handler/component_error_handler.dart';
import 'package:lk_client/model/authentication/api_key.dart';
import 'package:lk_client/model/discipline/student_work.dart';
import 'package:lk_client/model/discipline/teaching_material.dart';
import 'package:lk_client/model/education/timetable.dart';
import 'package:lk_client/model/education/timetable_item.dart';
import 'package:lk_client/model/listed_response.dart';
import 'package:lk_client/service/config/app_config.dart';
import 'package:lk_client/service/authentication_extractor.dart';
import 'package:lk_client/service/http_service.dart';
import 'package:lk_client/state/consuming_state.dart';
import 'package:lk_client/widget/list/teach_materials_list.dart';

class DisciplineQueryService {
  final ComponentErrorHandler apiErrorHandler;
  final AuthenticationExtractor authenticationExtractor;
  final ApiEndpointConsumer apiEndpointConsumer;

  DisciplineQueryService(this.apiEndpointConsumer, this.apiErrorHandler,
      this.authenticationExtractor);

  Stream<ConsumingState<Discipline>> getDisciplineItem(
      String discipline) async* {
    try {
      HttpResponse response = await this.apiEndpointConsumer.get(
          '/api/v1/student/discipline',
          <String, String>{'dis': discipline},
          await this.authenticationExtractor.getAuthenticationData);

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
      HttpResponse response = await this.apiEndpointConsumer.get(
          '/api/v1/student/discipline/teachers',
          <String, String>{
            'dis': discipline,
            'edu': education,
            'sem': semester
          },
          await this.authenticationExtractor.getAuthenticationData);

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

  Stream<ConsumingState<Timetable>> getDisciplineTimetable(
      String discipline, String education, String semester) async* {
    try {
      HttpResponse response = await this.apiEndpointConsumer.get(
          '/api/v1/student/discipline/timetable',
          <String, String>{
            'dis': discipline,
            'edu': education,
            'sem': semester
          },
          await this.authenticationExtractor.getAuthenticationData);

      if (response.status == 200) {
        Timetable timetable = Timetable.fromJson(response.body);
        yield ConsumingReadyState<Timetable>(timetable);
      } else {
        throw this.apiErrorHandler.apply(response.body);
      }
    } on Exception catch (e) {
      yield ConsumingErrorState<Timetable>(error: e);
    }
  }

  Stream<ConsumingState<ListedResponse<TeachingMaterial>>>
      getTeachingMaterialsList(
          String discipline, String education, String semester) async* {
    try {
      HttpResponse response = await this.apiEndpointConsumer.get(
          '/api/v1/materials/list',
          <String, String>{
            'dis': discipline,
            'edu': education,
            'sem': semester
          },
          await this.authenticationExtractor.getAuthenticationData);

      if (response.status == 200) {
        ListedResponse<TeachingMaterial> teachingMaterialsList =
            ListedResponse.fromJson(response.body, TeachingMaterial.fromJson);
        yield ConsumingReadyState(teachingMaterialsList);
      } else {
        throw this.apiErrorHandler.apply(response.body);
      }
    } on Exception catch (e) {
      yield ConsumingErrorState<ListedResponse<TeachingMaterial>>(error: e);
    }
  }

  Stream<ConsumingState<ListedResponse<StudentWork>>> getStudentWorkList(
      String education, String semester, String discipline) async* {
    try {
      HttpResponse response = await this.apiEndpointConsumer.get(
          '/api/v1/student/tasks/list',
          {'dis': discipline, 'edu': education, 'sem': semester},
          await this.authenticationExtractor.getAuthenticationData);

      if (response.status == 200) {
        ListedResponse<StudentWork> loadedStudentWorks =
            ListedResponse.fromJson(response.body, StudentWork.fromJson);
        yield ConsumingReadyState<ListedResponse<StudentWork>>(
            loadedStudentWorks);
      } else {
        yield ConsumingErrorState<ListedResponse<StudentWork>>(
            error: this.apiErrorHandler.apply(response.body));
      }
    } on Exception catch (e) {
      yield ConsumingErrorState<ListedResponse<StudentWork>>(error: e);
    }
  }
}
