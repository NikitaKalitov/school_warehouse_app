import 'package:flutter/material.dart';

import '../../data/models/item_model.dart';

const double _padding = 5;
const double _radius = 10;
const double _margin = 10;

class ItemWidget extends StatefulWidget {
  const ItemWidget({super.key, required this.item});

  final Item item;

  @override
  State<ItemWidget> createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  @override
  Widget build(BuildContext context) {
    return _ItemBodyWidget(children: [
      _ItemImageWidget(image: widget.item.image),
      _ItemTitleWidget(title: widget.item.title),
      _ItemTypeWidget(type: widget.item.type),
    ]);
  }
}

class _ItemBodyWidget extends StatelessWidget {
  const _ItemBodyWidget({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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

class _ItemImageWidget extends StatelessWidget {
  const _ItemImageWidget({super.key, required this.image});

  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 250,
      padding: const EdgeInsets.all(_padding),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_radius),
        child: Image.network(
          image,
          fit: BoxFit.cover,
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
    );
  }
}

class _ItemTitleWidget extends StatelessWidget {
  const _ItemTitleWidget({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title);
  }
}

class _ItemTypeWidget extends StatelessWidget {
  const _ItemTypeWidget({super.key, required this.type});

  final String type;

  @override
  Widget build(BuildContext context) {
    return Text(type);
  }
}

