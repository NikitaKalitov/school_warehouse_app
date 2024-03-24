import 'package:flutter/material.dart';

class RatingWidget extends StatelessWidget {
  const RatingWidget({super.key, required this.rating});

  final String rating;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.star),
          ),
          Text(rating),
        ],
      ),
    );
  }
}
