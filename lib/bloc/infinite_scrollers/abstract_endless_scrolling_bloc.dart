import 'package:lk_client/bloc/abstract_bloc.dart';
import 'package:lk_client/event/endless_scrolling_event.dart';
import 'package:lk_client/model/listed_response.dart';
import 'package:lk_client/state/endless_scrolling_state.dart';

abstract class AbstractEndlessScrollingBloc<T, C>
    extends AbstractBloc<EndlessScrollingState<T>, EndlessScrollingEvent> {
  Stream<EndlessScrollingState<T>> get endlessListScrollingStateStream => this
      .stateContoller
      .stream
      .where((event) => event is EndlessScrollingState<T>);

  Stream<EndlessScrollingEvent> get _nextChunkLoadEventStream => this
      .eventController
      .stream
      .where((event) => event is EndlessScrollingLoadEvent<C>);

  Stream<EndlessScrollingEvent> get _externalDataAddedEventStream => this
      .eventController
      .stream
      .where((event) => event is ExternalDataAddEvent<T>);

  /* Загружает очередой лист результата  */
  Future<ListedResponse<T>> loadListElementChunk(C command);

  /* Вернуть true при наличии следующих страниц */
  bool hasMoreChunks(ListedResponse<T> fresh);

  /* Возвращает составной список из предыдущих и загруженных результатов */
  List<T> copyPreviousToNew(List<T> previuos, List<T> fresh);

  /* Инициализация нового объекта команды для загрузки следующей страницы */
  C getNextChunkCommand(C baseCommand, int loaded, int remains);

  AbstractEndlessScrollingBloc() {
    this.updateState(EndlessScrollingInitState());

    /* this._nextChunkLoadEventStream.listen((event) async {
      final _event = event as EndlessScrollingLoadEvent<C>;
      this.updateState(EndlessScrollingLoadingState());
      try {
        ListedResponse<T> freshData =
            await this.loadListElementChunk(_event.command);
        C nextChunkCommand =
            this.getNextChunkCommand(_event.command, freshData);
        if (this.hasMoreChunks(freshData)) {
          this.updateState(EndlessScrollingChunkReadyState<T, C>(
              entityList: freshData.payload,
              nextChunkCommand: nextChunkCommand));
        } else {
          this.updateState(EndlessScrollingNoMoreDataState<T>(
              entityList: freshData.payload));
        }
      } on Exception catch (e) {
        this.updateState(EndlessScrollingErrorState<T>(error: e));
      }
    });*/

    this._nextChunkLoadEventStream.listen((event) async {
      final _event = event as EndlessScrollingLoadEvent<C>;

      if (currentState is EndlessScrollingLoadingState<T>) return;

      this.updateState(
          EndlessScrollingLoadingState<T>(entityList: currentState.entityList));

      try {
        C command = _event.command;
        if (currentState is EndlessScrollingChunkReadyState) {
          command = this.getNextChunkCommand(
              _event.command,
              currentState.entityList.length,
              (currentState as EndlessScrollingChunkReadyState).remains);
        }

        /**
         * Новый лист
         */
        ListedResponse<T> freshData = await this.loadListElementChunk(command);

        /**
         * Если предыдущий список был непустым, он копируется в новый
         */
        List<T> refreshData;
        if (currentState.entityList.length != 0) {
          refreshData = this
              .copyPreviousToNew(currentState.entityList, freshData.payload);
        } else {
          refreshData = freshData.payload;
        }

        this.updateState(EndlessScrollingChunkReadyState<T>(
            entityList: refreshData,
            remains: freshData.remains,
            hasMoreData: this.hasMoreChunks(freshData)));
      } on Exception catch (e) {
        this.updateState(EndlessScrollingErrorState<T>(
            entityList: currentState.entityList, error: e));
      }
    });

    this._externalDataAddedEventStream.listen((event) {
      final _event = event as ExternalDataAddEvent<T>;

      if (currentState is EndlessScrollingChunkReadyState) {
        this.updateState(EndlessScrollingChunkReadyState(
            entityList: _event.externalAddedData + currentState.entityList,
            hasMoreData:
                (currentState as EndlessScrollingChunkReadyState).hasMoreData,
            remains:
                (currentState as EndlessScrollingChunkReadyState).remains));
      }
    });
  }
}
