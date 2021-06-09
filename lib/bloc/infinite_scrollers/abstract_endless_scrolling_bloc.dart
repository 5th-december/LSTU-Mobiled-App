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
   * Стрим событий загрузки первой страницы списка
   * при этом ранее выполненные команды не учиываются
   * и список ранее загруженных элементов удаляется
   */
  Stream<EndlessScrollingEvent> get _firstChunkLoadEventStream => this
      .eventController
      .stream
      .where((event) => event is LoadFirstChunkEvent<C>);

  /*
   *  Стрим событий загрузки следующей страницы списка 
   *  при этом учитываются ранее добавленные элементы
   */
  Stream<EndlessScrollingEvent> get _nextChunkLoadEventStream => this
      .eventController
      .stream
      .where((event) => event is LoadNextChunkEvent<C>);

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
  C getNextChunkCommand(C previousCommand, C currentCommand, List<T> loaded,
      [int remains]);

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

    this._firstChunkLoadEventStream.listen((event) async {
      final _event = event as LoadFirstChunkEvent<C>;

      if (currentState is EndlessScrollingLoadingState<C, T>) return;

      this.updateState(
          EndlessScrollingLoadingState<C, T>(previousCommand: _event.command));

      try {
        /*
         * Первый лист результата 
         */
        ListedResponse<T> data =
            await this.loadListElementChunk(_event.command);

        this.updateState(EndlessScrollingChunkReadyState<C, T>(
            entityList: data.payload,
            remains: data.remains,
            hasMoreData: this.hasMoreChunks(data),
            previousCommand: _event.command));
      } on Exception catch (e) {
        this.updateState(EndlessScrollingErrorState<C, T>(
            error: e, previousCommand: _event.command));
      }
    });

    this._nextChunkLoadEventStream.listen((event) async {
      final _event = event as LoadNextChunkEvent<C>;

      if (!(currentState is EndlessScrollingChunkReadyState<C, T>)) return;

      final previousState =
          this.currentState as EndlessScrollingChunkReadyState<C, T>;

      try {
        final C command = this.getNextChunkCommand(
            previousState.previousCommand,
            _event.command,
            previousState.entityList,
            previousState.remains);

        this.updateState(EndlessScrollingLoadingState<C, T>(
            entityList: currentState.entityList, previousCommand: command));

        /**
         * Новый лист
         */
        ListedResponse<T> freshData = await this.loadListElementChunk(command);

        /**
         * Если предыдущий список был непустым, он копируется в новый
         */
        List<T> refreshData = [];

        if (previousState.entityList.length != 0) {
          refreshData = this
              .copyPreviousToNew(previousState.entityList, freshData.payload);
        } else {
          refreshData = freshData.payload;
        }

        this.updateState(EndlessScrollingChunkReadyState<C, T>(
            entityList: refreshData,
            remains: freshData.remains,
            hasMoreData: this.hasMoreChunks(freshData),
            previousCommand: command));
      } on Exception catch (e) {
        this.updateState(EndlessScrollingErrorState<C, T>(
            entityList: currentState.entityList,
            error: e,
            previousCommand: _event.command));
      }
    });

    this._externalDataAddedEventStream.listen((event) {
      final _event = event as ExternalDataAddEvent<T>;

      if (currentState is EndlessScrollingChunkReadyState<C, T>) {
        final _currentState =
            currentState as EndlessScrollingChunkReadyState<C, T>;
        this.updateState(EndlessScrollingChunkReadyState<C, T>(
            previousCommand: _currentState.previousCommand,
            entityList: this.addNewItemsToList(
                currentState.entityList, _event.externalAddedData),
            hasMoreData: _currentState.hasMoreData,
            remains: _currentState.remains));
      }
    });

    this._externalDataUpdateEventStream.listen((event) {
      final _event = event as ExternalDataUpdateEvent<T>;

      if (currentState is EndlessScrollingChunkReadyState<C, T>) {
        final _currentState =
            currentState as EndlessScrollingChunkReadyState<C, T>;
        this.updateState(EndlessScrollingChunkReadyState<C, T>(
            entityList: this.updateItemsInList(
                this.currentState.entityList, _event.externalUpdatedData),
            hasMoreData: _currentState.hasMoreData,
            previousCommand: _currentState.previousCommand,
            remains: _currentState.remains));
      }
    });
  }
}
