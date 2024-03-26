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
          currentItems: [],
          storehouseSortPattern: 'all',
          rackSortPattern: 'all',
          shelfSortPattern: 'all',
          typeSort: 'all',
          titleSearch: '',
          idSearch: '',
        ));

  void initCubit() async {
    var [allItems] = await SPrefProvider.getAllData();
    emit(state.copyWith(
      appStatus: AppStatus.loaded,
      allItems: allItems,
      currentItems: allItems,
    ));
  }

  void onChangedTitleSearch(String input) {
    emit(state.copyWith(titleSearch: input));
  }

  void onChangedIdSearch(String input) {
    emit(state.copyWith(idSearch: input));
  }

  void submitSearch() {
    emit(state.copyWith(currentItems: _sortItemsBySearch()));
  }

  void reset() {
    emit(state.copyWith(currentItems: state.allItems));
  }

  List<Item> _sortItemsBySearch() {
    List<Item> sortedListFirstCheck = [];
    for(int i = 0; i < state.currentItems!.length; i++){
      Item item = state.currentItems![i];
      if(state.titleSearch!.isNotEmpty) {
        if(item.title.toLowerCase().contains(state.titleSearch!.toLowerCase())){
          sortedListFirstCheck.add(item);
        }
      } else {
        sortedListFirstCheck.add(item);
      }
    }
    List<Item> sortedListSecondCheck = [];
    for(int i = 0; i < sortedListFirstCheck.length; i++){
      Item item = sortedListFirstCheck[i];
      if(state.idSearch!.isNotEmpty) {
        if(item.id == int.parse(state.titleSearch!)){
          sortedListSecondCheck.add(item);
        }
      } else {
        sortedListSecondCheck.add(item);
      }
    }
    return sortedListSecondCheck;
  }
}

class MainCubitState {
  AppStatus? appStatus;
  List<Item>? allItems;
  List<Item>? currentItems;
  String? storehouseSortPattern;
  String? rackSortPattern;
  String? shelfSortPattern;
  String? typeSort;
  String? titleSearch;
  String? idSearch;

  MainCubitState({
    this.appStatus,
    this.allItems,
    this.currentItems,
    this.storehouseSortPattern,
    this.rackSortPattern,
    this.shelfSortPattern,
    this.typeSort,
    this.titleSearch,
    this.idSearch,
  });

  MainCubitState copyWith({
    AppStatus? appStatus,
    List<Item>? allItems,
    List<Item>? currentItems,
    String? storehouseSortPattern,
    String? rackSortPattern,
    String? shelfSortPattern,
    String? typeSort,
    String? titleSearch,
    String? idSearch,
  }) {
    return MainCubitState(
      appStatus: appStatus ?? this.appStatus,
      allItems: allItems ?? this.allItems,
      currentItems: currentItems ?? this.currentItems,
      storehouseSortPattern:
          storehouseSortPattern ?? this.storehouseSortPattern,
      rackSortPattern: rackSortPattern ?? this.rackSortPattern,
      shelfSortPattern: shelfSortPattern ?? this.shelfSortPattern,
      typeSort: typeSort ?? this.typeSort,
      titleSearch: titleSearch ?? this.titleSearch,
      idSearch: idSearch ?? this.idSearch,
    );
  }
}
