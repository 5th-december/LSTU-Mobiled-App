import 'package:lk_client/bloc/abstract_bloc.dart';
import 'package:lk_client/event/endless_scrolling_event.dart';
import 'package:lk_client/model/listed_response.dart';
import 'package:lk_client/state/endless_scrolling_state.dart';

abstract class AbstractEndlessScrollingBloc<T, C> extends AbstractBloc<EndlessScrollingState<T>, EndlessScrollingEvent<C>> {

  Stream<EndlessScrollingState<T>> get endlessListScrollingStateStream 
    => this.stateContoller.stream.where((event) => event is EndlessScrollingState<T>);

  Stream<EndlessScrollingEvent<C>> get _endlessListLoadStream
    => this.eventController.stream.where((event) => event is EndlessScrollingLoadEvent<C>);

  Stream<EndlessScrollingEvent<C>> get _endlessListLoadNextChunkEventStream
    => this.eventController.stream.where((event) => event is EndlessScrollingLoadNextChunkEvent<C>);

  /* Загружает очередой лист результата  */
  Future<ListedResponse<T>> loadListElementChunk(C command);

  /* Вернуть bool при наличии следующих страниц */
  bool hasMoreChunks(ListedResponse<T> fresh);

  /* Возвращает составной список из предыдущих и загруженных результатов */
  List<T> copyPreviousToNew(List<T> previuos, List<T> fresh);

  /* Инициализация нового объекта команды для загрузки следующей страницы */
  C getNextChunkCommand(C previousCommand, ListedResponse<T> fresh);

  AbstractEndlessScrollingBloc() {
    this.updateState(EndlessScrollingInitState());

    this._endlessListLoadStream.listen((event) async {
      final _event = event as EndlessScrollingLoadEvent<C>;
      this.updateState(EndlessScrollingLoadingState());
      try {
        ListedResponse<T> freshData = await this.loadListElementChunk(_event.command);
        C nextChunkCommand = this.getNextChunkCommand(_event.command, freshData);
        if(this.hasMoreChunks(freshData)) {
          this.updateState(EndlessScrollingChunkReadyState<T, C>(
            entityList: freshData.payload, 
            nextChunkCommand: nextChunkCommand
          ));
        } else {
          this.updateState(EndlessScrollingNoMoreDataState<T>(
            entityList: freshData.payload
          ));
        }
      } on Exception catch(e) {
        this.updateState(EndlessScrollingErrorState<T>(error: e));
      }
    });

    this._endlessListLoadNextChunkEventStream.listen((event) async {
      final _event = event as EndlessScrollingLoadNextChunkEvent<C>;

      if(!(currentState is EndlessScrollingLoadingState<T>)) 
      {
        this.updateState(EndlessScrollingLoadingState<T>(
          entityList: currentState.entityList
        ));
        
        try {
          ListedResponse<T> freshData = await this.loadListElementChunk(_event.command);
          C nextChunkCommand = this.getNextChunkCommand(_event.command, freshData);
          List<T> refreshData;
          if(currentState.entityList.length != 0) {
            refreshData = this.copyPreviousToNew(currentState.entityList, freshData.payload);
          } else {
            refreshData = freshData.payload;
          }
          if(this.hasMoreChunks(freshData)) {
            this.updateState(EndlessScrollingChunkReadyState<T, C>(
              entityList: refreshData, 
              nextChunkCommand: nextChunkCommand
            ));
          } else {
            this.updateState(EndlessScrollingNoMoreDataState<T>(
              entityList: refreshData
            ));
          }
        } on Exception catch (e) {
          this.updateState(EndlessScrollingErrorState<T>(
            entityList: currentState.entityList, 
            error: e
          ));
        }
      }
    });
  }
}