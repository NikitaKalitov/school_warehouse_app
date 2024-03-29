import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/item_model.dart';

const String _defaultAllItems =
    '''{"items":[{"id": 1, "image":"https://static.insales-cdn.com/images/products/1/2784/205318880/a3d8debbcb3927a50c7991479ae63d3a55969982.png", "title":"Комикс по Рику", "storehouseId": 1, "rackId": 2, "shelfId": 2, "type": "Книги"}, {"id": 2, "image": "https://img.mvideo.ru/Pdb/4199178b.jpg", "title": "Смарт-Часы Xiaomi Poco Watch", "storehouseId":2, "rackId":1, "shelfId": 2, "type": "Смарт-часы"}, {"id": 3, "image": "https://ir.ozone.ru/s3/multimedia-l/c1000/6355295433.jpg", "title": "Врата Штейна", "storehouseId": 1, "rackId": 3, "shelfId": 2, "type":"Книги"},{"id": 4, "image": "https://upload.wikimedia.org/wikipedia/ru/3/32/Kimetsu_no_Yaiba_manga_volume_01.jpg", "title": "Клинок Рассекающий демонов", "storehouseId": 1, "rackId": 1, "shelfId": 3, "type": "Книги"},{"id": 5, "image": "https://cdn1.ozone.ru/s3/multimedia-m/6643941574.jpg", "title": "Far Cry. Прощение", "storehouseId": 1, "rackId": 3, "shelfId": 3, "type": "Книги"},{"id": 6, "image": "https://main-cdn.sbermegamarket.ru/big2/hlr-system/-4/17/80/02/13/52/3/100026624387b0.jpg", "title": "Война и мир том 1", "storehouseId": 1, "rackId": 3, "shelfId": 1, "type": "Книги"},{"id": 7, "image": "https://cdn.eksmo.ru/v2/ITD000000001067434/COVER/cover1__w600.jpg", "title": "Война и мир том 2", "storehouseId": 1, "rackId": 1, "shelfId": 2, "type": "Книги"},{"id": 8, "image": "https://ir.ozone.ru/s3/multimedia-p/c1000/6020010013.jpg", "title": "Война и мир том 3", "storehouseId": 1, "rackId": 1, "shelfId": 1, "type": "Книги"},{"id": 9, "image": "https://main-cdn.sbermegamarket.ru/big1/hlr-system/-4/17/77/71/49/52/3/100026624390b0.jpg", "title": "Война и мир том 4", "storehouseId": 1, "rackId": 2, "shelfId": 1, "type": "Книги"},{"id": 10, "image": "https://gdz.ru/attachments/images/covers/000/140/526/0000/gdz-10-class-algebra-merzlyak.jpg", "title": "Алгебра 10 класс Мерзляк", "storehouseId": 1, "rackId": 2, "shelfId": 3, "type": "Книги"},{"id": 11, "image": "https://cdn.ksyru0-fusion.fds.api.mi-img.com/b2c-mishop-pms-ru/pms_1569498776.25492659.png?w=400&h=400&thumb=1", "title": "Redmi Note 8 Pro", "storehouseId":2, "rackId":1, "shelfId": 3, "type": "Телефон"},{"id": 12, "image": "https://c.dns-shop.ru/thumb/st1/fit/300/300/540a270101361679dc6aa6fb815ee939/fbf20cca90f583aced0296c17c810d20980caa7202fb9669fa3a76871cc45900.jpg", "title": "MSI Katana 17", "storehouseId":2, "rackId":1, "shelfId": 1, "type": "Ноутбук"},{"id": 13, "image": "https://asus-store.ru/assets/images/laptop/vivobook/k3605/002.jpg", "title": "ASUS VivoBook 16X", "storehouseId":2, "rackId":3, "shelfId": 1, "type": "Ноутбук"},{"id": 14, "image": "https://ir.ozone.ru/s3/multimedia-x/c1000/6765356661.jpg", "title": "Xiaomi 13T Pro", "storehouseId":2, "rackId":2, "shelfId": 3, "type": "Телефон"},{"id": 15, "image": "https://ir.ozone.ru/s3/multimedia-o/c1000/6853911036.jpg", "title": "Tecno Spark 20", "storehouseId":2, "rackId":3, "shelfId": 3, "type": "Телефон"},{"id": 16, "image": "https://c.dns-shop.ru/thumb/st4/fit/500/500/d477d41f0c5ef07ea99560856a9eccb0/9f9cde09561b4c333e1c2a3c81a16e8bcaafd6d71c95d71cb3246e8702c0fa39.jpg", "title": "Aceline AHG-200", "storehouseId":2, "rackId":2, "shelfId": 2, "type": "Наушники"},{"id": 17, "image": "https://c.dns-shop.ru/thumb/st4/fit/500/500/02c265d23a914741ef0e876a178459cf/d3a0ffe57e37a21aaf5999924ce4a8ad377cac2811cdc053a8d4fa07be7c0016.jpg", "title": "SADES SA-721 Spirits", "storehouseId":2, "rackId":2, "shelfId": 1, "type": "Наушники"},{"id": 18, "image": "https://surgut.stores-apple.com/upload/iblock/4f4/826mctdk8ag70diy50bjdh6lf320cs0e.jpg", "title": "Смарт-Часы Apple Watch Ultra 2", "storehouseId":2, "rackId":3, "shelfId": 2, "type": "Смарт-часы"}]}''';

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
        'allItems', _Converter.putAllItemsToJson(allItems: allItems));
  }

  static Future<void> removeAllData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('allItems');
  }
}

class _Converter {
  static List<Item> getAllItemsFromJson(String json) {
    var listOfAllItemsJson = jsonDecode(json)['items'];
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
