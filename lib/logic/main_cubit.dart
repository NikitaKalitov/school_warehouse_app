import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/models/item_model.dart';
import '../data/storage/storage_provider.dart';

enum AppStatus {
  isLoading,
  loaded,
}

class MainCubit extends Cubit<MainCubitState> {
  MainCubit()
      : super(MainCubitState(
          appStatus: AppStatus.isLoading,
          allItems: [],
          filteredItems: [],
          searchItems: [],
          storehouseFilterPattern: -1,
          rackFilterPattern: -1,
          shelfFilterPattern: -1,
          storehouseFilterItems: [],
          rackFilterItems: [],
          shelfFilterItems: [],
          typeFilter: 'all',
          titleSearch: '',
          idSearch: '',
        ));

  // инициализация кубита
  // получаем данные из памяти (типа с сервера)
  void initCubit() async {
    var [allItems] = await SPrefProvider.getAllData();
    emit(state.copyWith(
      appStatus: AppStatus.loaded,
      // все предметы - это все предметы
      allItems: allItems,
      // при инициализации отфильтрованные предметы - тоже все предметы
      // потому что фильтра при инициализации нет
      searchItems: allItems,
      // ну и получаем уникальные id всех складов (не дублируются)
      storehouseFilterItems: _getDistinctStorehouseIds(allItems),
    ));
  }

  // метод, срабатывающий при изменении поля поиска по названию
  // здесь мы меняем паттерн поиска по названию
  void onChangedTitleSearch(String input) {
    emit(state.copyWith(titleSearch: input));
  }

  // метод, срабатывающий при изменении поля поиска по id предмета
  // здесь мы меняем паттерн поиска по id
  void onChangedIdSearch(String input) {
    emit(state.copyWith(idSearch: input));
  }

  // производим поиск по паттернам
  void submitSearch() {
    emit(state.copyWith(searchItems: _filterItemsBySearch()));
  }

  // сбрасываем результаты поиска
  void resetSearch() {
    // filteredItems нам нужен при ручном сбросе полей поиска
    emit(state.copyWith(searchItems: state.filteredItems));
  }

  // метод, срабатывающий при изменении id склада в выпадающем списке
  void changeStorehouseFilter(int newStorehouseFilter) {
    // если выбраны все склады
    if (newStorehouseFilter == -1) {
      emit(state.copyWith(
        // тогда отображаемые предметы и отсортированные предметы = все предметы из памяти
        searchItems: state.allItems,
        filteredItems: state.allItems,
        // записываем в паттерн склада -1
        storehouseFilterPattern: newStorehouseFilter,
        // список стеллажей пустой
        // чтобы выпадающий список стеллажей не отображался
        rackFilterItems: [],
        // паттерн для стеллажей сбрасываем
        rackFilterPattern: -1,
        // список полок пустой
        // чтобы выпадающий список полок не отображался
        shelfFilterItems: [],
        // паттерн для полок сбрасываем
        shelfFilterPattern: -1,
        // при изменении фильтра сбрасываем поля поиска
        idSearch: '',
        titleSearch: '',
      ));
      return;
    }
    // обновляем паттерн фильтрации по id склада
    emit(state.copyWith(storehouseFilterPattern: newStorehouseFilter));
    // фильтруем все предметы по id склада
    List<Item> itemsFilteredByStorehouseId =
        _filterByStorehouseId(state.allItems!);
    // получаем уникальные id стеллажей для выбранного склада
    List<int> distinctRackFilterIds =
        _getDistinctRackIds(itemsFilteredByStorehouseId);
    // записываем в стейт новые данные
    emit(state.copyWith(
      // отображаемые предметы отфильтрованы по id склада
      searchItems: itemsFilteredByStorehouseId,
      // отфильтрованные предметы отфильтрованы по id склада
      // (пока не понял, зачем это сделал)
      filteredItems: itemsFilteredByStorehouseId,
      // записываем в стейт список уникальных id стеллажей для выбранного склада
      rackFilterItems: distinctRackFilterIds,
      // сбрасываем фильтр по стеллажам
      rackFilterPattern: -1,
      // сбрасываем список уникальных id полок
      // чтобы выпадающий список полок не отображался
      shelfFilterItems: [],
      // сбрасываем фильтр по полкам
      shelfFilterPattern: -1,
      // при изменении фильтра сбрасываем поля поиска
      idSearch: '',
      titleSearch: '',
    ));
  }

  // метод, срабатывающий при изменении id стеллажа в выпадающем списке
  void changeRackFilter(int newRackFilter) {
    // если выбраны все стеллажи
    if (newRackFilter == -1) {
      emit(state.copyWith(
        // отображаемые и отфильтрованные предметы = отфильтрованные по id склада
        searchItems: _filterByStorehouseId(state.allItems!),
        filteredItems: _filterByStorehouseId(state.allItems!),
        // записываем -1 в фильтр стеллажа
        rackFilterPattern: newRackFilter,
        // сбрасываем список уникальных id полок
        // чтобы выпадающий список полок не отображался
        shelfFilterItems: [],
        // сбрасываем фильтр по полкам
        shelfFilterPattern: -1,
        // при изменении фильтра сбрасываем поля поиска
        idSearch: '',
        titleSearch: '',
      ));
      return;
    }
    // обновляем паттерн фильтрации по id стеллажа
    emit(state.copyWith(rackFilterPattern: newRackFilter));
    // фильтруем отфильтрованные по id склада предметы еще и по по id стеллажа
    List<Item> itemsFilteredByRackId =
        _filterByRackId(_filterByStorehouseId(state.allItems!));
    // получаем уникальные id полок для выбранного стеллажа
    List<int> distinctShelfFilterIds =
        _getDistinctShelfIds(itemsFilteredByRackId);
    // записываем в стейт новые данные
    emit(state.copyWith(
      // отображаемые предметы отфильтрованы по id стеллажа
      searchItems: itemsFilteredByRackId,
      // отфильтрованные предметы отфильтрованы по id стеллажа
      // (пока не понял, зачем это сделал)
      filteredItems: itemsFilteredByRackId,
      // записываем уникальные id полок для данного стеллажа
      shelfFilterItems: distinctShelfFilterIds,
      // сбрасываем фильтр по полкам
      shelfFilterPattern: -1,
      // при изменении фильтра сбрасываем поля поиска
      idSearch: '',
      titleSearch: '',
    ));
  }

  // метод, срабатывающий при изменении id полки в выпадающем списке
  void changeShelfFilter(int newShelfFilter) {
    // если выбраны все полки
    if (newShelfFilter == -1) {
      emit(state.copyWith(
        // отображаемые и отфильтрованные предметы =
        // = отфильтрованные по id склада и по id стеллажа
        searchItems: _filterByRackId(_filterByStorehouseId(state.allItems!)),
        filteredItems: _filterByRackId(_filterByStorehouseId(state.allItems!)),
        // записываем -1 в фильтр полки
        shelfFilterPattern: newShelfFilter,
        // при изменении фильтра сбрасываем поля поиска
        idSearch: '',
        titleSearch: '',
      ));
      return;
    }
    // обновляем паттерн фильтрации по id полки
    emit(state.copyWith(shelfFilterPattern: newShelfFilter));
    // фильтруем отфильтрованные по id склада и по id стеллажа предметы еще и по id полки
    List<Item> itemsFilteredByShelfId = _filterByShelfId(
        _filterByRackId(_filterByStorehouseId(state.allItems!)));
    // записываем в стейт новые данные
    emit(state.copyWith(
      // отображаемые предметы отфильтрованы по id стеллажа
      searchItems: itemsFilteredByShelfId,
      // отфильтрованные предметы отфильтрованы по id стеллажа
      // (пока не понял, зачем это сделал)
      filteredItems: itemsFilteredByShelfId,
      // при изменении фильтра сбрасываем поля поиска
      idSearch: '',
      titleSearch: '',
    ));
  }

  // фильтр предметов по полям поиска
  List<Item> _filterItemsBySearch() {
    List<Item> sortedListFirstCheck = [];
    // сначала фильтруем по названию, если оно не пустое
    if (state.titleSearch!.isNotEmpty) {
      // пробегаемся по списку предметов
      for (int i = 0; i < state.searchItems!.length; i++) {
        Item item = state.searchItems![i];
        // если введенное значение есть в названии
        if (item.title
            .toLowerCase()
            .contains(state.titleSearch!.toLowerCase())) {
          // то добавляем в список отсортированных по названию
          sortedListFirstCheck.add(item);
        }
      }
    }
    // если название пустое, то оставляем все предметы без фильтрации
    else {
      sortedListFirstCheck = state.searchItems!.toList();
    }
    List<Item> sortedListSecondCheck = [];
    // если поле поиска по id не пустое
    if (state.idSearch!.isNotEmpty) {
      // пробегаем по списку отсортированных по названию предметов
      for (int i = 0; i < sortedListFirstCheck.length; i++) {
        Item item = sortedListFirstCheck[i];
        // если введенное id совпадает с id предмета
        if (item.id == int.parse(state.titleSearch!)) {
          // добавляем его в список второй фильтрации
          sortedListSecondCheck.add(item);
        }
      }
    }
    // если поле id пустое, то оставляем фильтр только по названию
    else {
      sortedListSecondCheck = sortedListFirstCheck.toList();
    }
    return sortedListSecondCheck;
  }

  // фильтруем по id склада
  List<Item> _filterByStorehouseId(List<Item> input) {
    // не фильтруем, если выбраны все склады
    if (state.storehouseFilterPattern == -1) {
      return input;
    }
    int storehouseId = state.storehouseFilterPattern!;
    List<Item> itemsFilteredByStorehouseId = [];
    for (int i = 0; i < input.length; i++) {
      if (input[i].storehouseId == storehouseId) {
        itemsFilteredByStorehouseId.add(input[i]);
      }
    }
    return itemsFilteredByStorehouseId;
  }

  // фильтруем по id стеллажа
  List<Item> _filterByRackId(List<Item> input) {
    // не фильтруем, если выбраны все стеллажи
    if (state.rackFilterPattern == -1) {
      return input;
    }
    int rackId = state.rackFilterPattern!;
    List<Item> itemsFilteredByRackId = [];
    for (int i = 0; i < input.length; i++) {
      if (input[i].rackId == rackId) {
        itemsFilteredByRackId.add(input[i]);
      }
    }
    return itemsFilteredByRackId;
  }

  // фильтруем по id полки
  List<Item> _filterByShelfId(List<Item> input) {
    // не фильтруем, если выбраны все полки
    if (state.shelfFilterPattern == -1) {
      return input;
    }
    int shelfId = state.shelfFilterPattern!;
    List<Item> itemsFilteredByShelfId = [];
    for (int i = 0; i < input.length; i++) {
      if (input[i].shelfId == shelfId) {
        itemsFilteredByShelfId.add(input[i]);
      }
    }
    return itemsFilteredByShelfId;
  }

  // получить уникальные id складов в списке входящих предметов
  List<int> _getDistinctStorehouseIds(List<Item> input) {
    List<int> listOfAllStorehouseIds = [];
    for (int i = 0; i < input.length; i++) {
      listOfAllStorehouseIds.add(input[i].storehouseId);
    }
    listOfAllStorehouseIds = listOfAllStorehouseIds.toSet().toList();
    listOfAllStorehouseIds.sort((a, b) => a.compareTo(b));
    return listOfAllStorehouseIds;
  }

  // получить уникальные id стеллажей в списке входящих предметов
  List<int> _getDistinctRackIds(List<Item> input) {
    List<int> listOfAllRackIds = [];
    for (int i = 0; i < input.length; i++) {
      listOfAllRackIds.add(input[i].rackId);
    }
    listOfAllRackIds = listOfAllRackIds.toSet().toList();
    listOfAllRackIds.sort((a, b) => a.compareTo(b));
    return listOfAllRackIds;
  }

  // получить уникальные id полок в списке входящих предметов
  List<int> _getDistinctShelfIds(List<Item> input) {
    List<int> listOfAllShelfIds = [];
    for (int i = 0; i < input.length; i++) {
      listOfAllShelfIds.add(input[i].shelfId);
    }
    listOfAllShelfIds = listOfAllShelfIds.toSet().toList();
    listOfAllShelfIds.sort((a, b) => a.compareTo(b));
    return listOfAllShelfIds;
  }
}

class MainCubitState {
  AppStatus? appStatus;
  List<Item>? allItems;
  List<Item>? filteredItems;
  List<Item>? searchItems;
  int? storehouseFilterPattern;
  int? rackFilterPattern;
  int? shelfFilterPattern;
  List<int>? storehouseFilterItems;
  List<int>? rackFilterItems;
  List<int>? shelfFilterItems;
  String? typeFilter;
  String? titleSearch;
  String? idSearch;

  MainCubitState({
    this.appStatus,
    this.allItems,
    this.filteredItems,
    this.searchItems,
    this.storehouseFilterPattern,
    this.rackFilterPattern,
    this.shelfFilterPattern,
    this.storehouseFilterItems,
    this.rackFilterItems,
    this.shelfFilterItems,
    this.typeFilter,
    this.titleSearch,
    this.idSearch,
  });

  MainCubitState copyWith({
    AppStatus? appStatus,
    List<Item>? allItems,
    List<Item>? filteredItems,
    List<Item>? searchItems,
    int? storehouseFilterPattern,
    int? rackFilterPattern,
    int? shelfFilterPattern,
    List<int>? storehouseFilterItems,
    List<int>? rackFilterItems,
    List<int>? shelfFilterItems,
    String? typeFilter,
    String? titleSearch,
    String? idSearch,
  }) {
    return MainCubitState(
      appStatus: appStatus ?? this.appStatus,
      allItems: allItems ?? this.allItems,
      filteredItems: filteredItems ?? this.filteredItems,
      searchItems: searchItems ?? this.searchItems,
      storehouseFilterPattern:
          storehouseFilterPattern ?? this.storehouseFilterPattern,
      rackFilterPattern: rackFilterPattern ?? this.rackFilterPattern,
      shelfFilterPattern: shelfFilterPattern ?? this.shelfFilterPattern,
      storehouseFilterItems:
          storehouseFilterItems ?? this.storehouseFilterItems,
      rackFilterItems: rackFilterItems ?? this.rackFilterItems,
      shelfFilterItems: shelfFilterItems ?? this.shelfFilterItems,
      typeFilter: typeFilter ?? this.typeFilter,
      titleSearch: titleSearch ?? this.titleSearch,
      idSearch: idSearch ?? this.idSearch,
    );
  }
}
