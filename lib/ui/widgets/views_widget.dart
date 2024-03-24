import 'package:flutter/material.dart';

class ViewsWidget extends StatelessWidget {
  const ViewsWidget({super.key, required this.views});

  final String views;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.remove_red_eye_rounded),
          ),
          Text(views),
        ],
      ),
    );
  }
}
