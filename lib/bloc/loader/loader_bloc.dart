import 'package:lk_client/bloc/abstract_primitive_loader_bloc.dart';
import 'package:lk_client/command/consume_command.dart';
import 'package:lk_client/model/discipline/discipline.dart';
import 'package:lk_client/model/discipline/discussion_message.dart';
import 'package:lk_client/model/discipline/teaching_material.dart';
import 'package:lk_client/model/education/education.dart';
import 'package:lk_client/model/education/exam.dart';
import 'package:lk_client/model/education/semester.dart';
import 'package:lk_client/model/education/timetable.dart';
import 'package:lk_client/model/education/timetable_item.dart';
import 'package:lk_client/model/listed_response.dart';
import 'package:lk_client/model/messenger/dialog.dart';
import 'package:lk_client/model/messenger/private_message.dart';
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/model/person/profile_picture.dart';
import 'package:lk_client/service/api_consumer/discipline_query_service.dart';
import 'package:lk_client/service/api_consumer/education_query_service.dart';
import 'package:lk_client/service/api_consumer/messenger_query_service.dart';
import 'package:lk_client/service/api_consumer/person_query_service.dart';
import 'package:lk_client/state/consuming_state.dart';

class DisciplineTeachersListLoaderBloc extends AbstractPrimitiveLoaderBloc
  <LoadDisciplineTeacherList,
    ListedResponse<TimetableItem>,
    List<TimetableItem>> {
  DisciplineTeachersListLoaderBloc(DisciplineQueryService queryService) {
    this.loaderFunc = queryService.getDisciplineTeachers;
  }

  @override
  Stream<ConsumingState<ListedResponse<TimetableItem>>> commandArgumentTranslator(loaderFunc, LoadDisciplineTeacherList command) => loaderFunc(
    command.discipline.id, command.education.id,command.semester.id);
  
  @override
  List<TimetableItem> valueTranslator(ListedResponse<TimetableItem> argument) => argument.payload;
}

class DisciplineDetailsLoaderBloc extends AbstractPrimitiveLoaderBloc
  <LoadDisciplineDetails, Discipline, Discipline> {
  DisciplineDetailsLoaderBloc(DisciplineQueryService queryService) {
    this.loaderFunc = queryService.getDisciplineItem;
  }

  @override
  Stream<ConsumingState<Discipline>> commandArgumentTranslator(loaderFunc, LoadDisciplineDetails command) =>
    loaderFunc(command.discipline.id);

  @override
  Discipline valueTranslator(Discipline argument) => argument;
}

class ProfilePictureLoaderBloc extends AbstractPrimitiveLoaderBloc<LoadProfilePicture,
    ProfilePicture, ProfilePicture> {
  ProfilePictureLoaderBloc(PersonQueryService queryService) {
    this.loaderFunc = queryService.getPersonProfilePicture;
  }
  
  @override
  Stream<ConsumingState<ProfilePicture>> commandArgumentTranslator(loaderFunc, LoadProfilePicture command) {
    String size = command.size > 150? command.size > 400 ? 'lg': 'md': 'sm';
    return loaderFunc(command.person.id, size);
  }

  @override
  ProfilePicture valueTranslator(ProfilePicture argument) => argument;
}

class PersonalDetailsLoaderBloc
    extends AbstractPrimitiveLoaderBloc<LoadPersonDetails, Person, Person> {
  PersonalDetailsLoaderBloc(PersonQueryService queryService) {
    this.loaderFunc = queryService.getPersonProperties;
  }
  
  @override
  Stream<ConsumingState<Person>> commandArgumentTranslator(loaderFunc, LoadPersonDetails command) =>
    loaderFunc(command.person.id);

  @override
  Person valueTranslator(Person argument) => argument;
}

class UserDefinitionLoaderBloc
    extends AbstractPrimitiveLoaderBloc<LoadCurrentUserIdentifier, Person, Person> {
  UserDefinitionLoaderBloc(PersonQueryService queryService) {
    loaderFunc = queryService.getCurrentPersonIdentifier;
  }
  
  @override
  Stream<ConsumingState<Person>> commandArgumentTranslator(loaderFunc, LoadCurrentUserIdentifier command) => loaderFunc();

  @override
  Person valueTranslator(Person argument) => argument;
}

class EducationListLoaderBloc extends AbstractPrimitiveLoaderBloc<
    LoadUserEducationListCommand, ListedResponse<Education>, List<Education>> {
  EducationListLoaderBloc(EducationQueryService queryService) {
    loaderFunc = queryService.getEducationsList;
  }

  @override
  Stream<ConsumingState<ListedResponse<Education>>> commandArgumentTranslator
    (loaderFunc, LoadUserEducationListCommand command) => loaderFunc(command.person.id);
  
  @override
  List<Education> valueTranslator(ListedResponse<Education> argument) => argument.payload;
}

class SemesterListLoadingBloc extends AbstractPrimitiveLoaderBloc
    <LoadSemsterListCommand, ListedResponse<Semester>, List<Semester>> {
  SemesterListLoadingBloc(EducationQueryService queryService) {
    loaderFunc = queryService.getSemesterList;
  }

  @override
  Stream<ConsumingState<ListedResponse<Semester>>> commandArgumentTranslator (loaderFunc, LoadSemsterListCommand command) =>
    loaderFunc(command.education.id);
  
  @override
  List<Semester> valueTranslator(ListedResponse<Semester> argument) => argument.payload;
}

class SubjectListLoadingBloc extends AbstractPrimitiveLoaderBloc
  <LoadSubjectListCommand, ListedResponse<Discipline>, List<Discipline>> {
  SubjectListLoadingBloc(EducationQueryService queryService) {
    loaderFunc = queryService.getSubjectList;
  }

  @override
  Stream<ConsumingState<ListedResponse<Discipline>>> commandArgumentTranslator(loaderFunc, LoadSubjectListCommand command) =>
    loaderFunc(command.education.id, command.semester.id);
  
  @override
  List<Discipline> valueTranslator(ListedResponse<Discipline> argument) => argument.payload;
}

class DisciplineTimetableLoadingBloc
    extends AbstractPrimitiveLoaderBloc<LoadDisciplineTimetable, Timetable, Timetable> {
  DisciplineTimetableLoadingBloc(DisciplineQueryService queryService) {
    loaderFunc = queryService.getDisciplineTimetable;
  }

  @override
  Stream<ConsumingState<Timetable>> commandArgumentTranslator(loaderFunc, LoadDisciplineTimetable command) => 
    loaderFunc(command.discipline.id, command.education.id, command.semester.id);
   
  @override
  Timetable valueTranslator(Timetable argument) => argument;
}

class TeachingMaterialListLoadingBloc extends AbstractPrimitiveLoaderBloc
  <LoadTeachingMaterialsList, ListedResponse<TeachingMaterial>, List<TeachingMaterial>> {
  TeachingMaterialListLoadingBloc(DisciplineQueryService queryService) {
    loaderFunc = queryService.getTeachingMaterialsList;
  }

  @override
  Stream<ConsumingState<TeachingMaterial>> commandArgumentTranslator(loaderFunc, LoadTeachingMaterialsList command) => 
    loaderFunc(command.discipline.id, command.education.id, command.semester.id);
  
  @override
  List<TeachingMaterial> valueTranslator(ListedResponse<TeachingMaterial> argument) => argument.payload;
}

class PrivateChatMessagesListLoadingBloc extends AbstractPrimitiveLoaderBloc
    <LoadPrivateChatMessagesListCommand, ListedResponse<PrivateMessage>, ListedResponse<PrivateMessage>> {
  PrivateChatMessagesListLoadingBloc(MessengerQueryService messengerQueryService) {
    loaderFunc = messengerQueryService.getPrivateChatMessagesList;
  }

  @override
  Stream<ConsumingState<ListedResponse<PrivateMessage>>> commandArgumentTranslator(loaderFunc, LoadPrivateChatMessagesListCommand command) =>
    loaderFunc(command.dialog.id, command.count.toString(), command.offset.toString());

  @override
  ListedResponse<PrivateMessage> valueTranslator(ListedResponse argument) => argument;
}

class DialogListLoadingBloc extends AbstractPrimitiveLoaderBloc
  <LoadDialogListCommand, ListedResponse<Dialog>, ListedResponse<Dialog>> {
  DialogListLoadingBloc(MessengerQueryService messengerQueryService) {
    loaderFunc = messengerQueryService.getDialogList;
  }

  @override
  Stream<ConsumingState<ListedResponse<Dialog>>> commandArgumentTranslator(loaderFunc, LoadDialogListCommand command) =>
    loaderFunc(command.count.toString(), command.offset.toString());

  @override
  ListedResponse<Dialog> valueTranslator(ListedResponse<Dialog> argument) => argument;
}

class DiscussionLoadingBloc extends AbstractPrimitiveLoaderBloc
  <LoadDisciplineDiscussionListCommand, ListedResponse<DiscussionMessage>, ListedResponse<DiscussionMessage>> {
  DiscussionLoadingBloc(MessengerQueryService messengerQueryService) {
    loaderFunc = messengerQueryService.getDiscussionMessagesList;
  }

  @override
  Stream<ConsumingState<ListedResponse<DiscussionMessage>>> commandArgumentTranslator(loaderFunc, LoadDisciplineDiscussionListCommand command) =>
    loaderFunc(command.discipline.id, command.education.id, command.semester.id, command.count.toString(), command.offset.toString());

  @override
  ListedResponse<DiscussionMessage> valueTranslator(ListedResponse<DiscussionMessage> argument) => argument;
}

class TimetableLoadingBloc extends AbstractPrimitiveLoaderBloc<LoadTimetableCommand, Timetable, Timetable> {
  TimetableLoadingBloc(EducationQueryService educationQueryService) {
    loaderFunc = educationQueryService.getCurrentTimetable;
  }

  @override
  Stream<ConsumingState<Timetable>> commandArgumentTranslator(loaderFunc, LoadTimetableCommand command) =>
    loaderFunc(command.education.id, command.semester.id, command.weekType.type);

  @override
  Timetable valueTranslator(Timetable argument) => argument;
}

class ExamsTimetableLoadingBloc extends AbstractPrimitiveLoaderBloc<LoadExamsTimetableCommand, ListedResponse<Exam>, List<Exam>>
{
  ExamsTimetableLoadingBloc(EducationQueryService educationQueryService) {
    loaderFunc = educationQueryService.getExamsTimetable;
  }

  @override
  Stream<ConsumingState<ListedResponse<Exam>>> commandArgumentTranslator(loaderFunc, LoadExamsTimetableCommand command) =>
    loaderFunc(command.education.id, command.semester.id);

  @override
  List<Exam> valueTranslator(ListedResponse<Exam> argument) => argument.payload;
}