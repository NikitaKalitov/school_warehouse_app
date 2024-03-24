import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/item_model.dart';

const String _defaultAllItems =
    '''{"items":[{"id":1,"image":"https://cdn.icon-icons.com/icons2/1678/PNG/512/wondicon-ui-free-parcel_111208.png","title":"Комикс по Рику","storehouseId":1,"rackId":2,"shelfId":5,"type":"Книги"},{"id":2,"image":"https://cdn.icon-icons.com/icons2/1678/PNG/512/wondicon-ui-free-parcel_111208.png","title":"Часы Xiaomi Poco Watch","storehouseId":2,"rackId":1,"shelfId":2,"type":"Смарт-часы"},{"id":3,"image":"https://cdn.icon-icons.com/icons2/1678/PNG/512/wondicon-ui-free-parcel_111208.png","title":"Врата Штейна","storehouseId":1,"rackId":3,"shelfId":3,"type":"Книги"},{"id":4,"image":"https://cdn.icon-icons.com/icons2/1678/PNG/512/wondicon-ui-free-parcel_111208.png","title":"Клинок Рассекающий демонов","storehouseId":1,"rackId":3,"shelfId":3,"type":"Книги"},{"id":5,"image":"https://cdn.icon-icons.com/icons2/1678/PNG/512/wondicon-ui-free-parcel_111208.png","title":"Far Cry. Прощение","storehouseId":1,"rackId":3,"shelfId":3,"type":"Книги"}]}''';

///ключи для хранения и получения данных
///allItems

class SPrefProvider {
  static Future<List> getAllData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String allItemsJson =
        prefs.getString('allItems') ?? _defaultAllItems;

    return [
      _Converter.getAllItemsFromJson(allItemsJson),
    ];
  }

  static Future<void> saveAllData(
    List<Item> allItems
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'allHotels', _Converter.putAllItemsToJson(allItems: allItems));
  }

  static Future<void> removeAllData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('allItems');
  }
}

class _Converter {
  static List<Item> getAllItemsFromJson(String json) {
    var listOfAllItemsJson = jsonDecode(json);
    List<Item> listOfAllItems = [];
    for (int i = 0; i < listOfAllItemsJson.length; i++) {
      listOfAllItems.add(Item.fromMap(listOfAllItemsJson[i]));
    }
    return listOfAllItems;
  }

  static String putAllItemsToJson({required List<Item> allItems}) {
    List<Map<String, dynamic>> listOfAllItemsMap = [];
    for (int i = 0; i < allItems.length; i++) {
      listOfAllItemsMap.add(allItems[i].toMap());
    }
    String json = jsonEncode(listOfAllItemsMap);
    return json;
  }
}
