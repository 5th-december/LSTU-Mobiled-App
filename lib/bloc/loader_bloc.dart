import 'package:lk_client/bloc/primitive_loader_bloc.dart';
import 'package:lk_client/command/consume_command/discipline_request_command.dart';
import 'package:lk_client/model/discipline/discipline.dart';
import 'package:lk_client/model/education/timetable_item.dart';
import 'package:lk_client/model/listed_response.dart';
import 'package:lk_client/service/api_consumer/discipline_query_service.dart';

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
