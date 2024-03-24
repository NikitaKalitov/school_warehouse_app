import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/models/hotel_model.dart';
import '../data/models/place_model.dart';
import '../data/storage/storage_provider.dart';

enum AppStatus {
  isLoading,
  loaded,
}

class MainCubit extends Cubit<MainCubitState> {
  MainCubit()
      : super(MainCubitState(
          appStatus: AppStatus.isLoading,
          allHotels: [],
          allPlaces: [],
          favPlaces: [],
          favHotels: [],
          hotelsSortPattern: 'views desc',
          placesSortPattern: 'views desc',
        ));

  void initCubit() async {
    var [allHotels, allPlaces, favHotels, favPlaces] =
        await SPrefProvider.getAllData();
    emit(state.copyWith(
      appStatus: AppStatus.loaded,
      allHotels: allHotels,
      allPlaces: allPlaces,
      favHotels: favHotels,
      favPlaces: favPlaces,
    ));
    print('emit initCubit');
    sortHotels(state.hotelsSortPattern!);
    sortPlaces(state.placesSortPattern!);
  }

  void sortHotels(String pattern) {
    List<Hotel> listOfHotels = state.allHotels!.toList();
    switch(pattern) {
      case 'views desc':
        listOfHotels.sort((a, b) {
          return a.viewsInt.compareTo(b.viewsInt);
        });
        listOfHotels = listOfHotels.reversed.toList();
        break;
      case 'views asc':
        listOfHotels.sort((a, b) {
          return a.viewsInt.compareTo(b.viewsInt);
        });
        break;
      case 'rating desc':
        listOfHotels.sort((a, b) {
          return a.ratingDouble.compareTo(b.ratingDouble);
        });
        listOfHotels = listOfHotels.reversed.toList();
        break;
      case 'rating asc':
        listOfHotels.sort((a, b) {
          return a.ratingDouble.compareTo(b.ratingDouble);
        });
        break;
    }
    emit(state.copyWith(allHotels: listOfHotels, hotelsSortPattern: pattern));
    print('emit sortHotels');
  }

  void sortPlaces(String pattern) {
    List<Place> listOfPlaces = state.allPlaces!.toList();
    switch(pattern) {
      case 'views desc':
        listOfPlaces.sort((a, b) {
          return a.viewsInt.compareTo(b.viewsInt);
        });
        listOfPlaces = listOfPlaces.reversed.toList();
        break;
      case 'views asc':
        listOfPlaces.sort((a, b) {
          return a.viewsInt.compareTo(b.viewsInt);
        });
        break;
      case 'rating desc':
        listOfPlaces.sort((a, b) {
          return a.ratingDouble.compareTo(b.ratingDouble);
        });
        listOfPlaces = listOfPlaces.reversed.toList();
        break;
      case 'rating asc':
        listOfPlaces.sort((a, b) {
          return a.ratingDouble.compareTo(b.ratingDouble);
        });
        break;
    }
    emit(state.copyWith(allPlaces: listOfPlaces, placesSortPattern: pattern));
    print('emit sortPlaces');
  }

  void addOrRemoveFav(var object) {
    if(object is Hotel){
      _addOrRemoveFavHotel(object);
    } else {
      _addOrRemoveFavPlace(object);
    }
  }

  bool checkIfInFav(var object) {
    if(object is Hotel){
      return _checkIfInFavHotel(object);
    } else {
      return _checkIfInFavPlace(object);
    }
  }

  bool _checkIfInFavHotel(Hotel hotel) {
    bool contains = false;
    for(int i = 0; i < state.favHotels!.length; i++) {
      if(state.favHotels![i].id == hotel.id) {
        contains = true;
      }
    }
    return contains;
  }

  bool _checkIfInFavPlace(Place place) {
    bool contains = false;
    for(int i = 0; i < state.favPlaces!.length; i++) {
      if(state.favPlaces![i].id == place.id) {
        contains = true;
      }
    }
    return contains;
  }

  void _addOrRemoveFavHotel(Hotel hotel) {
    if(_checkIfInFavHotel(hotel)){
      _removeHotelFromFav(hotel);
    } else {
      _addHotelToFav(hotel);
    }
  }

  void _addHotelToFav(Hotel hotel) async {
    List<Hotel> favHotels = [...state.favHotels!, hotel];
    await SPrefProvider.saveFavHotels(favHotels);
    emit(state.copyWith(favHotels: favHotels));
    print('emit _addHotelToFav');
  }

  void _removeHotelFromFav(Hotel hotel) async {
    List<Hotel> favHotels = [...state.favHotels!];
    favHotels.removeWhere((element) => element.id == hotel.id);
    await SPrefProvider.saveFavHotels(favHotels);
    emit(state.copyWith(favHotels: favHotels));
    print('emit _removeHotelFromFav');
  }

  void _addOrRemoveFavPlace(Place place) {
    if(_checkIfInFavPlace(place)){
      _removePlaceFromFav(place);
    } else {
      _addPlaceToFav(place);
    }
  }

  void _addPlaceToFav(Place place) async {
    List<Place> favPlaces = [...state.favPlaces!, place];
    await SPrefProvider.saveFavPlaces(favPlaces);
    emit(state.copyWith(favPlaces: favPlaces));
    print('emit _addPlaceToFav');
  }

  void _removePlaceFromFav(Place place) async {
    List<Place> favPlaces = [...state.favPlaces!];
    favPlaces.removeWhere((element) => element.id == place.id);
    await SPrefProvider.saveFavPlaces(favPlaces);
    emit(state.copyWith(favPlaces: favPlaces));
    print('emit _removePlaceFromFav');
  }
}

class MainCubitState {
  AppStatus? appStatus;
  List<Hotel>? allHotels;
  List<Hotel>? favHotels;
  List<Place>? allPlaces;
  List<Place>? favPlaces;
  String? hotelsSortPattern;
  String? placesSortPattern;

  MainCubitState({
    this.appStatus,
    this.allHotels,
    this.allPlaces,
    this.favHotels,
    this.favPlaces,
    this.hotelsSortPattern,
    this.placesSortPattern,
  });

  MainCubitState copyWith({
    AppStatus? appStatus,
    List<Hotel>? allHotels,
    List<Hotel>? favHotels,
    List<Place>? allPlaces,
    List<Place>? favPlaces,
    String? hotelsSortPattern,
    String? placesSortPattern,
  }) {
    return MainCubitState(
      appStatus: appStatus ?? this.appStatus,
      allHotels: allHotels ?? this.allHotels,
      allPlaces: allPlaces ?? this.allPlaces,
      favHotels: favHotels ?? this.favHotels,
      favPlaces: favPlaces ?? this.favPlaces,
      hotelsSortPattern: hotelsSortPattern ?? this.hotelsSortPattern,
      placesSortPattern: placesSortPattern ?? this.placesSortPattern,
    );
  }
}
