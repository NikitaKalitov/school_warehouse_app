import 'package:flutter/material.dart';

const double _padding = 5;
const double _radius = 10;
const double _margin = 10;
const double _width = 300;

class FavouriteWidget extends StatefulWidget {
  const FavouriteWidget({
    super.key,
    required this.id,
    required this.type,
    required this.image,
    required this.title,
  });

  final int id;
  final String type;
  final String image;
  final String title;

  @override
  State<FavouriteWidget> createState() => _FavouriteWidgetState();
}

class _FavouriteWidgetState extends State<FavouriteWidget> {
  @override
  Widget build(BuildContext context) {
    return _FavouriteBodyWidget(
      children: [
        _FavouriteImageWidget(image: widget.image),
        _FavouriteTitleWidget(title: widget.title),
      ],
    );
  }
}

class _FavouriteBodyWidget extends StatelessWidget {
  const _FavouriteBodyWidget({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _width,
      padding: const EdgeInsets.all(_padding),
      margin: const EdgeInsets.all(_margin),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(_radius)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(1, 1), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children,
      ),
    );
  }
}

class _FavouriteImageWidget extends StatelessWidget {
  const _FavouriteImageWidget({super.key, required this.image});

  final String image;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 4,
      child: Container(
        width: _width,
        padding: const EdgeInsets.all(_padding),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(_radius),
          child: Image.network(
            image,
            fit: BoxFit.fill,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _FavouriteTitleWidget extends StatelessWidget {
  const _FavouriteTitleWidget({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(title),
    );
  }
}
