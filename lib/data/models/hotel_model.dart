class Hotel {
  int id;
  String image;
  String title;
  String address;
  String phone;
  String rating;
  String views;
  double ratingDouble;
  int viewsInt;

  Hotel({
    required this.id,
    required this.image,
    required this.title,
    required this.address,
    required this.phone,
    required this.rating,
    required this.views,
    required this.ratingDouble,
    required this.viewsInt,
  });

  static Hotel fromMap(Map<String, dynamic> map) {
    return Hotel(
      id: map['id'],
      image: map['image'],
      title: map['title'],
      address: map['address'],
      phone: map['phone'],
      rating: map['rating'],
      views: map['views'],
      ratingDouble: double.parse(map['rating'].replaceAll(',', '.')),
      viewsInt: int.parse(map['views']),
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> hotelAsMap = {
      'id': id,
      'image': image,
      'title': title,
      'address': address,
      'phone': phone,
      'rating': rating,
      'views': views,
    };
    return hotelAsMap;
  }
}
