import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/hotel_model.dart';
import '../models/place_model.dart';

const String _defaultAllHotels =
    '''[{"id":1,"image":"https://regatta-hotel-ulyanovsk.nochi.com/data/Photos/OriginalPhoto/7131/713198/713198827/Regatta-Hotel-Ulyanovsk-Exterior.JPEG","title":"Regatta","address":"avenue. Narimanova, 16","phone":"+7 (8422) 21-44-88","rating":"5,0","views":"150"},{"id":2,"image":"https://avatars.mds.yandex.net/get-altay/4660612/2a0000017aeb18ca78fee814576cac0a69e4/orig","title":"Radisson","address":"Goncharova str., 25","phone":"+7 (8422) 25-00-55","rating":"5,0","views":"164"},{"id":3,"image":"https://www.frontdesk.ru/sites/default/files/images/2017/12/pic-679d8f1ae995410cd7949b866c98113c.jpg","title":"Imperial Club Deluxe 5","address":"Alexandrovskaya str., 60","phone":"+7 (8422) 28-72-58","rating":"5,0","views":"138"},{"id":4,"image":"http://d2xf5gjipzd8cd.cloudfront.net/available/335389593/335389593_WxH.jpg","title":"October 3","address":"Plekhanov str., 1","phone":"+7 (8422) 42-53-43","rating":"4,7","views":"102"},{"id":5,"image":"https://avatars.mds.yandex.net/get-altay/6249106/2a00000182bac04603acf3246eda6a942d27/XXL","title":"AZIMUT","address":"Spasskaya St., 19/9","phone":"+7 (8422) 44-17-00","rating":"4,4","views":"111"},{"id":6,"image":"https://a.travelcdn.mts.ru/property-photos/1633728227/2347900126/ee83efc07b2d6f161fa2d5c7147a729e5e3654fb.jpeg","title":"Art Ulyanovsk","address":"Brestskaya str., 78, p. 6","phone":"+7 (8422) 75-65-11","rating":"4,7","views":"84"},{"id":7,"image":"https://hotelsimbirsk.ru/base/attachments/upload-1675big.jpg","title":"Simbirsk","address":"Krasnoarmeyskaya str., 2","phone":"+7 (927) 825-33-65","rating":"4,8","views":"149"},{"id":8,"image":"https://i0.photo.2gis.com/images/branch/0/30258560079966770_9ef2.jpg","title":"Rakurs","address":"Kirov str., 79","phone":"+7 (8422) 27-04-50","rating":"5,0","views":"92"},{"id":9,"image":"https://edem-v-gosti.ru/upload/iblock/ba0/pfsintmiaue886xunqbcn7v5rsg36jcv/EmptyName-38.jpg","title":"Bruno","address":"Karamzinskaya str., 15","phone":"+7 (8422) 73-70-12","rating":"5,0","views":"125"},{"id":10,"image":"https://oldsimbirsk-hotel.ru/wp-content/uploads/2021/12/gostinica-60.jpg","title":"Oldsimbirsk","address":"Krasnoarmeyskaya str., 93","phone":"+7 (8422) 38-41-43","rating":"4,9","views":"99"},{"id":11,"image":"https://cdn-img.readytotrip.com/t/1024x768/extranet/fa/c8/fac86a21b89a931cd22f416c5f05d1b1d849b08c.jpeg","title":"Boutique Hotel 1881","address":"Karl Marx str., 13/2","phone":"+7 (8422) 58-78-30","rating":"4,7","views":"104"},{"id":12,"image":"https://hotels.sletat.ru/i/f/105124_10.jpg","title":"Goncharov","address":"Federation str., 112","phone":"+7 (951) 095-59-45","rating":"4,5","views":"77"},{"id":13,"image":"https://avatars.mds.yandex.net/get-altay/878647/2a0000016287410cf29a2596a4cdf64d400b/XXL_height","title":"Vip House","address":"4th Quarter str., 6","phone":"+7 (960) 372-01-60","rating":"4,6","views":"83"},{"id":14,"image":"https://a.travelcdn.mts.ru/property-photos/1633728227/2347900126/15e04dbd3269970911b1e91d5cd3ebbfcdccab64.jpeg","title":"Simbirsk-aparts","address":"Gagarin str., 28","phone":"+7 (927) 806-55-72","rating":"4,7","views":"103"},{"id":15,"image":"https://hotelsimbirsk.ru/base/data/3358mid.JPG","title":"Art Simbirsk","address":"Federation str., 52A","phone":"+7 (937) 279-94-31","rating":"4,9","views":"116"}]''';
const String _defaultAllPlaces =
    '''[{"id":1,"image":"https://tur-ray.ru/wp-content/uploads/2018/01/dom-goncharova.jpg","title":"Goncharov's House","description":"In one of his rooms in this mansion in 1812, the Russian writer Ivan Goncharov was born","rating":"4,7","views":"99"},{"id":2,"image":"https://static.tildacdn.com/stor3337-3837-4161-b263-323762373139/30570368.jpg","title":"Lenin Memorial","description":"It is one of the largest scientific, cultural and historical centers of Ulyanovsk","rating":"4,9","views":"83"},{"id":3,"image":"https://avatars.dzeninfra.ru/get-zen_doc/1209363/pub_62daa5e674984a2364e84f39_62dab3959d059c55fec86803/scale_1200","title":"Memorial on Victory Square","description":"47-meter white stele was created in memory of the military","rating":"4,5","views":"93"},{"id":4,"image":"https://tur-ray.ru/wp-content/uploads/2018/01/dom-kuptsa-bokounina.jpg","title":"The house of the merchant Bokounin","description":"The fabulous teremok is a monument of wooden architecture, is one of the architectural gems of the city","rating":"4,7","views":"110"},{"id":5,"image":"https://tur-ray.ru/wp-content/uploads/2018/01/besedka-goncharova-v-vinnovskoy-rosche.jpg","title":"Goncharov's gazebo in the Vinnovskaya grove","description":"The monument to A.Goncharov is installed in the form of a gazebo","rating":"5,0","views":"99"},{"id":6,"image":"https://tur-ray.ru/wp-content/uploads/2018/01/filosofskiy-divan-oblomova.jpg","title":"Oblomov's Philosophical sofa","description":"The famous Oblomov sofa, on which the famous literary character loved to lie and philosophize so much","rating":"4,4","views":"52"},{"id":7,"image":"https://kyda-shodit.ru/wp-content/uploads/2023/08/kuda-skhodit-v-ulyanovske-11-1.jpg","title":"The Museum of Photography","description":"The museum allows you to immerse yourself in the era of the beginning of photography","rating":"5,0","views":"136"},{"id":8,"image":"https://kyda-shodit.ru/wp-content/uploads/2023/08/kuda-skhodit-v-ulyanovske-14-1.jpg","title":"Local History Museum","description":"The richest funds of the museum allow organizing interesting exhibitions since the 20th century","rating":"4,9","views":"194"},{"id":9,"image":"https://kyda-shodit.ru/wp-content/uploads/2023/08/kuda-skhodit-v-ulyanovske-16-1.jpg","title":"Regional Drama Theatre","description":"The theater of the city is proud of its history. The best actors of the country once played on his stage","rating":"4,8","views":"157"},{"id":10,"image":"https://proprostranstva.ru/wp-content/uploads/2021/04/kvartal2.jpg","title":"Creative business space Kvartal","description":"It is a place for useful communication, combining business and creativity","rating":"5,0","views":"83"},{"id":11,"image":"https://kyda-shodit.ru/wp-content/uploads/2023/08/kuda-skhodit-v-ulyanovske-18-1.jpg","title":"Zoo","description":"Visitors will be able to see more than 120 different animals from all parts of the world","rating":"4,6","views":"98"},{"id":12,"image":"https://cdn.culture.ru/images/5d9cee5a-fda6-5b64-a2b9-9ef9fddd1499","title":"Plastov Museum of Modern Fine Arts","description":"The museum's exposition includes: art from different years, works by Arkady Plastov","rating":"4,9","views":"104"},{"id":13,"image":"https://tripplanet.ru/wp-content/uploads/europe/russia/ulyanovsk/civil-aviation-history-museum.jpg","title":"Aviation Museum","description":"The museum has an airfield and four halls with exhibits illustrating the history of aviation","rating":"4,7","views":"79"},{"id":14,"image":"https://i2.photo.2gis.com/images/geo/55/7740561904477254_e4b5.jpg","title":"Peoples' Friendship Park","description":"The park's hiking trails stretch from the highest point of the city to the banks of the Volga River","rating":"4,6","views":"92"},{"id":15,"image":"https://mosaica.ru/uploads/AdminNode/attachments/2021-11-28/1638077980/custom_style_250449.png","title":"Puppet Theater","description":"The museum of the theater houses a collection of 60 puppet figures, which are more than 110 years old","rating":"4,5","views":"64"}]''';
const String _defaultFavHotels = '[]';
// const String _defaultFavHotels = '''[{"id":1,"image":"https://regatta-hotel-ulyanovsk.nochi.com/data/Photos/OriginalPhoto/7131/713198/713198827/Regatta-Hotel-Ulyanovsk-Exterior.JPEG","title":"Regatta","address":"avenue. Narimanova, 16","phone":"+7 (8422) 21-44-88"},{"id":2,"image":"https://avatars.mds.yandex.net/get-altay/4660612/2a0000017aeb18ca78fee814576cac0a69e4/orig","title":"Radisson","address":"Goncharova str., 25","phone":"+7 (8422) 25-00-55"},{"id":3,"image":"https://www.frontdesk.ru/sites/default/files/images/2017/12/pic-679d8f1ae995410cd7949b866c98113c.jpg","title":"Imperial Club Deluxe 5","address":"Alexandrovskaya str., 60","phone":"+7 (8422) 28-72-58"},{"id":4,"image":"http://d2xf5gjipzd8cd.cloudfront.net/available/335389593/335389593_WxH.jpg","title":"October 3","address":"Plekhanov str., 1","phone":"+7 (8422) 42-53-43"},{"id":5,"image":"https://avatars.mds.yandex.net/get-altay/6249106/2a00000182bac04603acf3246eda6a942d27/XXL","title":"AZIMUT","address":"Spasskaya St., 19/9","phone":"+7 (8422) 44-17-00"},{"id":6,"image":"https://a.travelcdn.mts.ru/property-photos/1633728227/2347900126/ee83efc07b2d6f161fa2d5c7147a729e5e3654fb.jpeg","title":"Art Ulyanovsk","address":"Brestskaya str., 78, p. 6","phone":"+7 (8422) 75-65-11"},{"id":7,"image":"https://hotelsimbirsk.ru/base/attachments/upload-1675big.jpg","title":"Simbirsk","address":"Krasnoarmeyskaya str., 2","phone":"+7 (927) 825-33-65"},{"id":8,"image":"https://i0.photo.2gis.com/images/branch/0/30258560079966770_9ef2.jpg","title":"Rakurs","address":"Kirov str., 79","phone":"+7 (8422) 27-04-50"},{"id":9,"image":"https://edem-v-gosti.ru/upload/iblock/ba0/pfsintmiaue886xunqbcn7v5rsg36jcv/EmptyName-38.jpg","title":"Bruno","address":"Karamzinskaya str., 15","phone":"+7 (8422) 73-70-12"},{"id":10,"image":"https://oldsimbirsk-hotel.ru/wp-content/uploads/2021/12/gostinica-60.jpg","title":"Oldsimbirsk","address":"Krasnoarmeyskaya str., 93","phone":"+7 (8422) 38-41-43"},{"id":11,"image":"https://cdn-img.readytotrip.com/t/1024x768/extranet/fa/c8/fac86a21b89a931cd22f416c5f05d1b1d849b08c.jpeg","title":"Boutique Hotel 1881","address":"Karl Marx str., 13/2","phone":"+7 (8422) 58-78-30"},{"id":12,"image":"https://hotels.sletat.ru/i/f/105124_10.jpg","title":"Goncharov","address":"Federation str., 112","phone":"+7 (951) 095-59-45"},{"id":13,"image":"https://avatars.mds.yandex.net/get-altay/878647/2a0000016287410cf29a2596a4cdf64d400b/XXL_height","title":"Vip House","address":"4th Quarter str., 6","phone":"+7 (960) 372-01-60"},{"id":14,"image":"https://a.travelcdn.mts.ru/property-photos/1633728227/2347900126/15e04dbd3269970911b1e91d5cd3ebbfcdccab64.jpeg","title":"Simbirsk-aparts","address":"Gagarin str., 28","phone":"+7 (927) 806-55-72"},{"id":15,"image":"https://hotelsimbirsk.ru/base/data/3358mid.JPG","title":"Art Simbirsk","address":"Federation str., 52A","phone":"+7 (937) 279-94-31"}]''';
const String _defaultFavPlaces = '[]';
// const String _defaultFavPlaces = '''[{"id":1,"image":"https://tur-ray.ru/wp-content/uploads/2018/01/dom-goncharova.jpg","title":"Goncharov's House","description":"In one of his rooms in this mansion in 1812, the Russian writer Ivan Goncharov was born"},{"id":2,"image":"https://static.tildacdn.com/stor3337-3837-4161-b263-323762373139/30570368.jpg","title":"Lenin Memorial","description":"It is one of the largest scientific, cultural and historical centers of Ulyanovsk"},{"id":3,"image":"https://avatars.dzeninfra.ru/get-zen_doc/1209363/pub_62daa5e674984a2364e84f39_62dab3959d059c55fec86803/scale_1200","title":"Memorial on Victory Square","description":"47-meter white stele was created in memory of the military"},{"id":4,"image":"https://tur-ray.ru/wp-content/uploads/2018/01/dom-kuptsa-bokounina.jpg","title":"The house of the merchant Bokounin","description":"The fabulous teremok is a monument of wooden architecture, is one of the architectural gems of the city"},{"id":5,"image":"https://tur-ray.ru/wp-content/uploads/2018/01/besedka-goncharova-v-vinnovskoy-rosche.jpg","title":"Goncharov's gazebo in the Vinnovskaya grove","description":"The monument to A.Goncharov is installed in the form of a gazebo."},{"id":6,"image":"https://tur-ray.ru/wp-content/uploads/2018/01/filosofskiy-divan-oblomova.jpg","title":"Oblomov's Philosophical sofa","description":"The famous Oblomov sofa, on which the famous literary character loved to lie and philosophize so much"},{"id":7,"image":"https://kyda-shodit.ru/wp-content/uploads/2023/08/kuda-skhodit-v-ulyanovske-11-1.jpg","title":"The Museum of Photography","description":"The museum allows you to immerse yourself in the era of the beginning of photography"},{"id":8,"image":"https://kyda-shodit.ru/wp-content/uploads/2023/08/kuda-skhodit-v-ulyanovske-14-1.jpg","title":"Local History Museum","description":"The richest funds of the museum allow organizing interesting exhibitions since the 20th century"},{"id":9,"image":"https://kyda-shodit.ru/wp-content/uploads/2023/08/kuda-skhodit-v-ulyanovske-16-1.jpg","title":"Regional Drama Theatre","description":"The theater of the city is proud of its history. The best actors of the country once played on his stage"},{"id":10,"image":"https://proprostranstva.ru/wp-content/uploads/2021/04/kvartal2.jpg","title":"Creative business space Kvartal","description":"It is a place for useful communication, combining business and creativity"},{"id":11,"image":"https://kyda-shodit.ru/wp-content/uploads/2023/08/kuda-skhodit-v-ulyanovske-18-1.jpg","title":"Zoo","description":"Visitors will be able to see more than 120 different animals from all parts of the world"},{"id":12,"image":"https://cdn.culture.ru/images/5d9cee5a-fda6-5b64-a2b9-9ef9fddd1499","title":"Plastov Museum of Modern Fine Arts","description":"The museum's exposition includes: art from different years, works by Arkady Plastov"},{"id":13,"image":"https://tripplanet.ru/wp-content/uploads/europe/russia/ulyanovsk/civil-aviation-history-museum.jpg","title":"Aviation Museum","description":"The museum has an airfield and four halls with exhibits illustrating the history of aviation"},{"id":14,"image":"https://i2.photo.2gis.com/images/geo/55/7740561904477254_e4b5.jpg","title":"Peoples' Friendship Park","description":"The park's hiking trails stretch from the highest point of the city to the banks of the Volga River"},{"id":15,"image":"https://mosaica.ru/uploads/AdminNode/attachments/2021-11-28/1638077980/custom_style_250449.png","title":"Puppet Theater","description":"The museum of the theater houses a collection of 60 puppet figures, which are more than 110 years old"}]''';

///ключи для хранения и получения данных
///allHotels allPlaces favHotels favPlaces

class SPrefProvider {
  static Future<List> getAllData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String allHotelsJson =
        prefs.getString('allHotels') ??
            _defaultAllHotels;
    final String allPlacesJson =
        prefs.getString('allPlaces') ??
            _defaultAllPlaces;
    final String favHotelsJson =
        prefs.getString('favHotels') ??
            _defaultFavHotels;
    final String favPlacesJson =
        prefs.getString('favPlaces') ??
            _defaultFavPlaces;

    return [
      _Converter.getAllHotelsFromJson(allHotelsJson),
      _Converter.getAllPlacesFromJson(allPlacesJson),
      _Converter.getFavHotelsFromJson(favHotelsJson),
      _Converter.getFavPlacesFromJson(favPlacesJson),
    ];
  }

  static Future<void> saveAllHotels(List<Hotel> allHotels) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'allHotels', _Converter.putAllHotelsToJson(allHotels: allHotels));
  }

  static Future<void> saveAllPlaces(List<Place> allPlaces) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'allPlaces', _Converter.putAllPlacesToJson(allPlaces: allPlaces));
  }

  static Future<void> saveFavHotels(List<Hotel> favHotels) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'favHotels', _Converter.putFavHotelsToJson(favHotels: favHotels));
  }

  static Future<void> saveFavPlaces(List<Place> favPlaces) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'favPlaces', _Converter.putFavPlacesToJson(favPlaces: favPlaces));
  }

  static Future<void> saveAllData(
    List<Hotel> allHotels,
    List<Place> allPlaces,
    List<Hotel> favHotels,
    List<Place> favPlaces,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'allHotels', _Converter.putAllHotelsToJson(allHotels: allHotels));
    await prefs.setString(
        'allPlaces', _Converter.putAllPlacesToJson(allPlaces: allPlaces));
    await prefs.setString(
        'favHotels', _Converter.putFavHotelsToJson(favHotels: favHotels));
    await prefs.setString(
        'favPlaces', _Converter.putFavPlacesToJson(favPlaces: favPlaces));
  }

  static Future<void> removeAllData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('allHotels');
    await prefs.remove('allPlaces');
    await prefs.remove('favHotels');
    await prefs.remove('favPlaces');
  }
}

class _Converter {
  static List<Hotel> getAllHotelsFromJson(String json) {
    var listOfAllHotelsJson = jsonDecode(json);
    List<Hotel> listOfAllHotels = [];
    for (int i = 0; i < listOfAllHotelsJson.length; i++) {
      listOfAllHotels.add(Hotel.fromMap(listOfAllHotelsJson[i]));
    }
    return listOfAllHotels;
  }

  static List<Place> getAllPlacesFromJson(String json) {
    var listOfAllPlacesJson = jsonDecode(json);
    List<Place> listOfAllPlaces = [];
    for (int i = 0; i < listOfAllPlacesJson.length; i++) {
      listOfAllPlaces.add(Place.fromMap(listOfAllPlacesJson[i]));
    }
    return listOfAllPlaces;
  }

  static List<Hotel> getFavHotelsFromJson(String json) {
    var listOfFavHotelsJson = jsonDecode(json);
    List<Hotel> listOfFavHotels = [];
    for (int i = 0; i < listOfFavHotelsJson.length; i++) {
      listOfFavHotels.add(Hotel.fromMap(listOfFavHotelsJson[i]));
    }
    return listOfFavHotels;
  }

  static List<Place> getFavPlacesFromJson(String json) {
    var listOfFavPlacesJson = jsonDecode(json);
    List<Place> listOfFavPlaces = [];
    for (int i = 0; i < listOfFavPlacesJson.length; i++) {
      listOfFavPlaces.add(Place.fromMap(listOfFavPlacesJson[i]));
    }
    return listOfFavPlaces;
  }

  static String putAllHotelsToJson({required List<Hotel> allHotels}) {
    List<Map<String, dynamic>> listOfAllHotelsMap = [];
    for (int i = 0; i < allHotels.length; i++) {
      listOfAllHotelsMap.add(allHotels[i].toMap());
    }
    String json = jsonEncode(listOfAllHotelsMap);
    return json;
  }

  static String putAllPlacesToJson({required List<Place> allPlaces}) {
    List<Map<String, dynamic>> listOfAllPlacesMap = [];
    for (int i = 0; i < allPlaces.length; i++) {
      listOfAllPlacesMap.add(allPlaces[i].toMap());
    }
    String json = jsonEncode(listOfAllPlacesMap);
    return json;
  }

  static String putFavHotelsToJson({required List<Hotel> favHotels}) {
    List<Map<String, dynamic>> listOfFavHotelsMap = [];
    for (int i = 0; i < favHotels.length; i++) {
      listOfFavHotelsMap.add(favHotels[i].toMap());
    }
    String json = jsonEncode(listOfFavHotelsMap);
    return json;
  }

  static String putFavPlacesToJson({required List<Place> favPlaces}) {
    List<Map<String, dynamic>> listOfFavPlacesMap = [];
    for (int i = 0; i < favPlaces.length; i++) {
      listOfFavPlacesMap.add(favPlaces[i].toMap());
    }
    String json = jsonEncode(listOfFavPlacesMap);
    return json;
  }
}
