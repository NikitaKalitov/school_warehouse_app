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
    emit(state.copyWith(searchItems: _sortItemsBySearch()));
  }

  // сбрасываем результаты поиска
  void resetSearch() {
    emit(state.copyWith(searchItems: state.allItems));
  }

  // метод, срабатывающий при изменении id склада в выпадающем списке
  void changeStorehouseFilter(int newStorehouseFilter) {
    if (newStorehouseFilter == -1) {
      emit(state.copyWith(
        searchItems: state.allItems,
        filteredItems: state.allItems,
        storehouseFilterPattern: newStorehouseFilter,
        rackFilterItems: [],
        rackFilterPattern: -1,
        shelfFilterItems: [],
        shelfFilterPattern: -1,
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
      shelfFilterItems: [],
      // сбрасываем фильтр по полкам
      shelfFilterPattern: -1,
    ));
  }

  // метод, срабатывающий при изменении id стеллажа в выпадающем списке
  void changeRackFilter(int newRackFilter) {
    // если выбраны все
    if (newRackFilter == -1) {
      emit(state.copyWith(
        searchItems: _filterByStorehouseId(state.allItems!),
        filteredItems: _filterByStorehouseId(state.allItems!),
        rackFilterPattern: newRackFilter,
        shelfFilterItems: [],
        shelfFilterPattern: -1,
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
    ));
  }

  void changeShelfFilter(int newShelfFilter) {}

  void submitFilter() {
    // _filterAllItemsByAllFilters();
  }

  List<Item> _sortItemsBySearch() {
    List<Item> sortedListFirstCheck = [];
    for (int i = 0; i < state.searchItems!.length; i++) {
      Item item = state.searchItems![i];
      if (state.titleSearch!.isNotEmpty) {
        if (item.title
            .toLowerCase()
            .contains(state.titleSearch!.toLowerCase())) {
          sortedListFirstCheck.add(item);
        }
      } else {
        sortedListFirstCheck.add(item);
      }
    }
    List<Item> sortedListSecondCheck = [];
    for (int i = 0; i < sortedListFirstCheck.length; i++) {
      Item item = sortedListFirstCheck[i];
      if (state.idSearch!.isNotEmpty) {
        if (item.id == int.parse(state.titleSearch!)) {
          sortedListSecondCheck.add(item);
        }
      } else {
        sortedListSecondCheck.add(item);
      }
    }
    return sortedListSecondCheck;
  }

  void _filterAllItemsByAllFilters() {
    List<Item> itemsFilteredByStorehouseId =
        _filterByStorehouseId(state.allItems!);
    List<Item> itemsFilteredByStorehouseIdAndRackId =
        _filterByRackId(itemsFilteredByStorehouseId);
    List<Item> itemsFilteredByStorehouseIdAndRackIdAndShelfId =
        _filterByShelfId(itemsFilteredByStorehouseIdAndRackId);
    emit(state.copyWith(
        filteredItems: itemsFilteredByStorehouseIdAndRackIdAndShelfId));
  }

  List<Item> _filterByStorehouseId(List<Item> input) {
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

  List<Item> _filterByRackId(List<Item> input) {
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

  List<Item> _filterByShelfId(List<Item> input) {
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

  List<int> _getDistinctStorehouseIds(List<Item> input) {
    List<int> listOfAllStorehouseIds = [];
    for (int i = 0; i < input.length; i++) {
      listOfAllStorehouseIds.add(input[i].storehouseId);
    }
    return listOfAllStorehouseIds.toSet().toList();
  }

  List<int> _getDistinctRackIds(List<Item> input) {
    List<int> listOfAllRackIds = [];
    for (int i = 0; i < input.length; i++) {
      listOfAllRackIds.add(input[i].rackId);
    }
    return listOfAllRackIds.toSet().toList();
  }

  List<int> _getDistinctShelfIds(List<Item> input) {
    List<int> listOfAllShelfIds = [];
    for (int i = 0; i < input.length; i++) {
      listOfAllShelfIds.add(input[i].shelfId);
    }
    return listOfAllShelfIds.toSet().toList();
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
