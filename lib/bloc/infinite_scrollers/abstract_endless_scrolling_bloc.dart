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

  /*
   * Стрим событий начальной инициализации списка, 
   * может содержать изначально добавленные элементы
   */
  Stream<EndlessScrollingEvent> get _dialogListInitEventStream => this
      .eventController
      .stream
      .where((event) => event is EndlessScrollingInitEvent<T>);

  /*
   *  Стрим событий загрузки следующей страницы списка 
   *  при этом учитываются ранее добавленные элементы
   */
  Stream<EndlessScrollingEvent> get _nextChunkLoadEventStream => this
      .eventController
      .stream
      .where((event) => event is EndlessScrollingLoadEvent<C>);

  /*
   * Стрим событий добавления списка извне блока
   */
  Stream<EndlessScrollingEvent> get _externalDataAddedEventStream => this
      .eventController
      .stream
      .where((event) => event is ExternalDataAddEvent<T>);

  /*
   * Стрим событий обновления списка извне блока 
   */
  Stream<EndlessScrollingEvent> get _externalDataUpdateEventStream => this
      .eventController
      .stream
      .where((event) => event is ExternalDataUpdateEvent<T>);

  /*
   * Загружает очередой лист результата
   */
  Future<ListedResponse<T>> loadListElementChunk(C command);

  /*
   * Вернуть true при наличии следующих страниц
   */
  bool hasMoreChunks(ListedResponse<T> fresh);

  /*
   * Возвращает составной список из предыдущих и загруженных результатов
   */
  List<T> copyPreviousToNew(List<T> previuos, List<T> fresh);

  /*
   * Инициализация нового объекта команды для загрузки следующей страницы
   */
  C getNextChunkCommand(C baseCommand, List<T> loaded, [int remains]);

  /*
   * Обновляет элементы имеющегося списка из добавленного
   * По умолчанию игнорирует обновление
   * В подклассах поведение необходимо изменять, 
   * если есть необходимость в динамическом обновлении 
   * контента в списке, например, из события external update
   */
  List<T> updateItemsInList(List<T> actual, List<T> update) {
    return actual;
  }

  /*
   * Добавление в список новых элементов
   * По умолчанию элементы добавляются в конец
   * В подклассах поведение может быть изменено
   * 
   * В таких списках, как чаты новые элементы всегда
   * добавляются в начало списка, поэтому в таких
   * подклассах их изменение обязательно
   */
  List<T> addNewItemsToList(List<T> actual, List<T> additional) {
    final addedList = List<T>.from(actual);
    addedList.addAll(additional);
    return addedList;
  }

  AbstractEndlessScrollingBloc() {
    this._dialogListInitEventStream.listen((event) {
      this.updateState(EndlessScrollingInitState<T>());
    });

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
              currentState.entityList,
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

      if (currentState is EndlessScrollingChunkReadyState<T>) {
        this.updateState(EndlessScrollingChunkReadyState<T>(
            entityList: this.addNewItemsToList(
                currentState.entityList, _event.externalAddedData),
            hasMoreData: (currentState as EndlessScrollingChunkReadyState<T>)
                .hasMoreData,
            remains:
                (currentState as EndlessScrollingChunkReadyState<T>).remains));
      }
    });

    this._externalDataUpdateEventStream.listen((event) {
      final _event = event as ExternalDataUpdateEvent<T>;

      if (currentState is EndlessScrollingChunkReadyState) {
        this.updateState(EndlessScrollingChunkReadyState<T>(
            entityList: this.updateItemsInList(
                this.currentState.entityList, _event.externalUpdatedData),
            hasMoreData: (currentState as EndlessScrollingChunkReadyState<T>)
                .hasMoreData,
            remains:
                (currentState as EndlessScrollingChunkReadyState<T>).remains));
      }
    });
  }
}
