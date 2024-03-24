class Place {
  int id;
  String image;
  String title;
  String description;
  String rating;
  String views;
  double ratingDouble;
  int viewsInt;

  Place({
    required this.id,
    required this.image,
    required this.title,
    required this.description,
    required this.rating,
    required this.views,
    required this.ratingDouble,
    required this.viewsInt,
  });

  static Place fromMap(Map<String, dynamic> map) {
    return Place(
      id: map['id'],
      image: map['image'],
      title: map['title'],
      description: map['description'],
      rating: map['rating'],
      views: map['views'],
      ratingDouble: double.parse(map['rating'].replaceAll(',', '.')),
      viewsInt: int.parse(map['views']),
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'id': id,
      'image': image,
      'title': title,
      'description': description,
      'rating': rating,
      'views': views,
    };
    return map;
  }
}
