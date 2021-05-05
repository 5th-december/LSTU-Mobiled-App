import 'package:lk_client/bloc/primitive_loader_bloc.dart';
import 'package:lk_client/command/consume_command/discipline_request_command.dart';
import 'package:lk_client/model/education/timetable_item.dart';
import 'package:lk_client/model/listed_response.dart';
import 'package:lk_client/service/api_consumer/discipline_query_service.dart';

class DisciplineTeachersListLoaderBloc extends 
  PrimitiveLoaderBloc<LoadDisciplineTeacherList, ListedResponse<TimetableItem>, List<TimetableItem>>{
  
  DisciplineTeachersListLoaderBloc(DisciplineQueryService queryService): super(
    loaderFunc: queryService.getDisciplineTeachers,
    commandArgumentTranslator: (loaderFunc, LoadDisciplineTeacherList command) => loaderFunc(command.discipline, command.education, command.semester),
    valueTranslator: (ListedResponse<TimetableItem> argument) => argument.payload
  );
}