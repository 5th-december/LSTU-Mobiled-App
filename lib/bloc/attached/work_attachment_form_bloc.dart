import 'package:flutter/foundation.dart';
import 'package:lk_client/bloc/attached/abstract_form_bloc.dart';
import 'package:lk_client/command/produce_command.dart';
import 'package:lk_client/model/discipline/work_answer_attachment.dart';
import 'package:lk_client/model/validatable.dart';
import 'package:lk_client/service/api_consumer/discipline_query_service.dart';

class WorkAttachmentFormBloc extends AbstractFormBloc<WorkAnswerAttachment,
    SendWorkAnswerAttachment, WorkAnswerAttachment> {
  final DisciplineQueryService disciplineQueryService;

  WorkAttachmentFormBloc({@required this.disciplineQueryService});
  @override
  WorkAnswerAttachment createInitialFormData(WorkAnswerAttachment argument) {
    return argument;
  }

  @override
  Future<WorkAnswerAttachment> getResponse(
      WorkAnswerAttachment request, SendWorkAnswerAttachment command) async {
    return await this.disciplineQueryService.sendNewWorkAnswerAttachment(
        request, command.education.id, command.studentWork.id);
  }

  @override
  ValidationErrorBox validateEntity(WorkAnswerAttachment argument) {
    return argument.validate();
  }
}
