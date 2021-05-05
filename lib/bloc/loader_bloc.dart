import 'package:lk_client/bloc/primitive_loader_bloc.dart';
import 'package:lk_client/command/consume_command/discipline_request_command.dart';
import 'package:lk_client/command/consume_command/education_request_command.dart';
import 'package:lk_client/command/consume_command/user_request_command.dart';
import 'package:lk_client/model/discipline/discipline.dart';
import 'package:lk_client/model/education/education.dart';
import 'package:lk_client/model/education/semester.dart';
import 'package:lk_client/model/education/timetable.dart';
import 'package:lk_client/model/education/timetable_item.dart';
import 'package:lk_client/model/listed_response.dart';
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/model/person/profile_picture.dart';
import 'package:lk_client/service/api_consumer/discipline_query_service.dart';
import 'package:lk_client/service/api_consumer/education_query_service.dart';
import 'package:lk_client/service/api_consumer/person_query_service.dart';

class DisciplineTeachersListLoaderBloc extends PrimitiveLoaderBloc<
    LoadDisciplineTeacherList,
    ListedResponse<TimetableItem>,
    List<TimetableItem>> {
  DisciplineTeachersListLoaderBloc(DisciplineQueryService queryService)
      : super(
            loaderFunc: queryService.getDisciplineTeachers,
            commandArgumentTranslator:
                (loaderFunc, LoadDisciplineTeacherList command) => loaderFunc(
                    command.discipline.id,
                    command.education.id,
                    command.semester.id),
            valueTranslator: (ListedResponse<TimetableItem> argument) =>
                argument.payload);
}

class DisciplineDetailsLoaderBloc
    extends PrimitiveLoaderBloc<LoadDisciplineDetails, Discipline, Discipline> {
  DisciplineDetailsLoaderBloc(DisciplineQueryService queryService)
      : super(
            commandArgumentTranslator:
                (loaderFunc, LoadDisciplineDetails command) =>
                    loaderFunc(command.discipline.id),
            loaderFunc: queryService.getDisciplineItem);
}

class ProfilePictureLoaderBloc extends PrimitiveLoaderBloc<LoadProfilePicture, ProfilePicture, ProfilePicture> {
  ProfilePictureLoaderBloc(PersonQueryService queryService): super(
    loaderFunc: queryService.getPersonProfilePicture,
    commandArgumentTranslator: (loaderFunc, LoadProfilePicture command) {
      String size = command.size > 150 ? command.size > 400 ? 'lg': 'md': 'sm';
      return loaderFunc(command.person.id, size);
    }
  );
}

class PersonalDetailsLoaderBloc extends PrimitiveLoaderBloc<LoadPersonDetails, Person, Person> {
  PersonalDetailsLoaderBloc(PersonQueryService queryService): super(
    loaderFunc: queryService.getPersonProperties,
    commandArgumentTranslator: (loaderFunc, LoadPersonDetails command) => loaderFunc(command.person.id), 
  );
}

class UserDefinitionLoaderBloc extends PrimitiveLoaderBloc<LoadCurrentUserIdentifier, Person, Person> {
  UserDefinitionLoaderBloc(PersonQueryService queryService): super(
    loaderFunc: queryService.getCurrentPersonIdentifier,
    commandArgumentTranslator: (loaderFunc, LoadCurrentUserIdentifier command) => loaderFunc()
  );
}

class EducationDetailsLoaderBloc extends PrimitiveLoaderBloc<LoadCurrentEducationsCommand, ListedResponse<Education>, List<Education>> {
  EducationDetailsLoaderBloc(EducationQueryService queryService): super(
    loaderFunc: queryService.getEducationsList,
    commandArgumentTranslator: (loaderFunc, LoadCurrentEducationsCommand command) => loaderFunc(command.person.id),
    valueTranslator: (ListedResponse<Education> argument) => argument.payload
  );
}

class EducationListLoaderBloc extends PrimitiveLoaderBloc<LoadUserEducationListCommand, ListedResponse<Education>, List<Education>> {
  EducationListLoaderBloc(EducationQueryService queryService): super(
    loaderFunc: queryService.getEducationsList,
    commandArgumentTranslator: (loaderFunc, LoadUserEducationListCommand command) => loaderFunc(command.person.id),
    valueTranslator: (ListedResponse<Education> argument) => argument.payload
  );
}

class SemesterListLoadingBloc extends PrimitiveLoaderBloc<LoadSemsterListCommand, ListedResponse<Semester>, List<Semester>> {
  SemesterListLoadingBloc(EducationQueryService queryService): super(
    loaderFunc: queryService.getSemesterList,
    commandArgumentTranslator: (loaderFunc, LoadSemsterListCommand command) => loaderFunc(command.education.id),
    valueTranslator: (ListedResponse<Semester> argument) => argument.payload
  );
}

class SubjectListLoadingBloc extends PrimitiveLoaderBloc<LoadSubjectListCommand, ListedResponse<Discipline>, List<Discipline>> {
  SubjectListLoadingBloc(EducationQueryService queryService): super(
    loaderFunc: queryService.getSubjectList,
    commandArgumentTranslator: (loaderFunc, LoadSubjectListCommand command) => loaderFunc(command.education.id, command.semester.id),
    valueTranslator: (ListedResponse<Discipline> argument) => argument.payload
  );
}

class DisciplineTimetableLoadingBloc extends PrimitiveLoaderBloc<LoadDisciplineTimetable, Timetable, Timetable> {
  DisciplineTimetableLoadingBloc(DisciplineQueryService queryService): super(
    loaderFunc: queryService.getDisciplineTimetable,
    commandArgumentTranslator: (loaderFunc, LoadDisciplineTimetable command) => 
        loaderFunc(command.discipline.id, command.education.id, command.semester.id)
  );
}