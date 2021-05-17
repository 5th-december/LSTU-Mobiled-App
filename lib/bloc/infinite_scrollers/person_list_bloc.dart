import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:lk_client/bloc/infinite_scrollers/abstract_endless_scrolling_bloc.dart';
import 'package:lk_client/command/consume_command.dart';
import 'package:lk_client/model/listed_response.dart';
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/service/api_consumer/person_query_service.dart';
import 'package:lk_client/state/consuming_state.dart';

class PersonListBloc extends AbstractEndlessScrollingBloc<Person, LoadPersonListByTextQuery> {
  final PersonQueryService personQueryService;

  PersonListBloc({@required this.personQueryService});
  @override
  List<Person> copyPreviousToNew(List<Person> previuos, List<Person> fresh) {
    List<Person> payload = List<Person>.from(previuos); 
    payload.addAll(fresh);
    return payload;
  }

  @override
  bool hasMoreChunks(ListedResponse<Person> fresh) {
    return fresh.remains > 0;
  }

  @override
  LoadPersonListByTextQuery getNextChunkCommand(LoadPersonListByTextQuery previousCommand, ListedResponse<Person> fresh) {
    return LoadPersonListByTextQuery(
      count: min(previousCommand.count, fresh.remains),
      offset: previousCommand.offset + fresh.count,
      textQuery: previousCommand.textQuery
    );
  }

  @override
  Future<ListedResponse<Person>> loadListElementChunk(LoadPersonListByTextQuery command) async {
    Stream<ConsumingState<ListedResponse<Person>>> personsListStream = 
      this.personQueryService.getPersonList(command.textQuery, command.count.toString(), command.offset.toString());
    await for (ConsumingState<ListedResponse<Person>> state in personsListStream) {
      if(state is ConsumingErrorState<ListedResponse<Person>>) {
        throw state.error;
      } else if (state is ConsumingReadyState<ListedResponse<Person>>) {
        return state.content;
      }
    }
  }
}