import 'package:lk_client/bloc/abstract_bloc.dart';
import 'package:lk_client/event/endless_scrolling_event.dart';
import 'package:lk_client/model/listed_response.dart';
import 'package:lk_client/state/endless_scrolling_state.dart';

abstract class AbstractEndlessScrollingBloc<T, C> extends AbstractBloc<EndlessScrollingState<T>, EndlessScrollingEvent<C>> {

  Stream<EndlessScrollingState<T>> get endlessListScrollingStateStream 
    => this.stateContoller.stream.where((event) => event is EndlessScrollingState<T>);

  Stream<EndlessScrollingEvent<C>> get _endlessListLoadChunkEventStream
    => this.eventController.stream.where((event) => event is EndlessScrollingLoadChunkEvent<C>);

  Future<ListedResponse<T>> loadListElementChunk(C command);
  bool hasMoreChunks(ListedResponse<T> fresh);
  ListedResponse<T> copyPreviousToNew(ListedResponse<T> previuos, ListedResponse<T> fresh);

  AbstractEndlessScrollingBloc() {
    this.updateState(EndlessScrollingInitState<T>(entityList: ListedResponse(payload: [])));

    this._endlessListLoadChunkEventStream.listen((event) async {
      final _event = event as EndlessScrollingLoadChunkEvent<C>;

      if(currentState is EndlessScrollingInitState<T> || 
          currentState is EndlessScrollingErrorState<T> || 
          currentState is EndlessScrollingChunkReadyState<T>) 
        {
        this.updateState(EndlessScrollingLoadingState<T>(entityList: currentState.entityList));
        
        try {
          ListedResponse<T> freshData = await this.loadListElementChunk(_event.command);

          ListedResponse<T> refreshData;
          if(currentState is EndlessScrollingErrorState<T> || currentState is EndlessScrollingChunkReadyState<T>) {
            refreshData = this.copyPreviousToNew(currentState.entityList, freshData);
          } else {
            refreshData = currentState.entityList;
          }

          if(this.hasMoreChunks(freshData)) {
            this.updateState(EndlessScrollingChunkReadyState<T>(entityList: refreshData));
          } else {
            this.updateState(EndlessScrollingNoMoreDataState<T>(entityList: freshData));
          }
          
        } on Exception catch (e) {
          this.updateState(EndlessScrollingErrorState<T>(entityList: currentState.entityList));
        }
      }
    });
  }
}