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
          storehouseSortPattern: 'all',
          rackSortPattern: 'all',
          shelfSortPattern: 'all',
          typeSort: 'all',
        ));

  void initCubit() async {
    var [allItems] = await SPrefProvider.getAllData();
    emit(state.copyWith(
      appStatus: AppStatus.loaded,
      allItems: allItems,
    ));
  }
}

class MainCubitState {
  AppStatus? appStatus;
  List<Item>? allItems;
  String? storehouseSortPattern;
  String? rackSortPattern;
  String? shelfSortPattern;
  String? typeSort;

  MainCubitState({
    this.appStatus,
    this.allItems,
    this.storehouseSortPattern,
    this.rackSortPattern,
    this.shelfSortPattern,
    this.typeSort,
  });

  MainCubitState copyWith({
    AppStatus? appStatus,
    List<Item>? allItems,
    String? storehouseSortPattern,
    String? rackSortPattern,
    String? shelfSortPattern,
    String? typeSort,
  }) {
    return MainCubitState(
      appStatus: appStatus ?? this.appStatus,
      allItems: allItems ?? this.allItems,
      storehouseSortPattern:
          storehouseSortPattern ?? this.storehouseSortPattern,
      rackSortPattern: rackSortPattern ?? this.rackSortPattern,
      shelfSortPattern: shelfSortPattern ?? this.shelfSortPattern,
      typeSort: typeSort ?? this.typeSort,
    );
  }
}
