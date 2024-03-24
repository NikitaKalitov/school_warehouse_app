class Item {
  int id;
  String image;
  String title;
  int storehouseId;
  int rackId;
  int shelfId;
  String type;

  Item({
    required this.id,
    required this.image,
    required this.title,
    required this.storehouseId,
    required this.rackId,
    required this.shelfId,
    required this.type,
  });

  static Item fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'],
      image: map['image'],
      title: map['title'],
      storehouseId: map['storehouseId'],
      rackId: map['rackId'],
      shelfId: map['shelfId'],
      type: map['type'],
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> itemAsMap = {
      'id': id,
      'image': image,
      'title': title,
      'storehouseId': storehouseId,
      'rackId': rackId,
      'shelfId': shelfId,
      'type': type,
    };
    return itemAsMap;
  }
}