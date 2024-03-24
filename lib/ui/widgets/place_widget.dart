import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_2_dasha_eve/ui/widgets/rating_widget.dart';
import 'package:school_2_dasha_eve/ui/widgets/views_widget.dart';

import '../../data/models/place_model.dart';
import '../../logic/main_cubit.dart';

const double _padding = 5;
const double _radius = 10;
const double _margin = 10;

class PlaceWidget extends StatefulWidget {
  const PlaceWidget({super.key, required this.place});

  final Place place;

  @override
  State<PlaceWidget> createState() => _PlaceWidgetState();
}

class _PlaceWidgetState extends State<PlaceWidget> {
  @override
  Widget build(BuildContext context) {
    return _PlaceBodyWidget(children: [
      _PlaceImageWidget(image: widget.place.image),
      _PlaceTitleWidget(title: widget.place.title),
      _PlaceDescriptionWidget(description: widget.place.description),
      _PlaceRatingAndViewsWidget(children: [
        RatingWidget(rating: widget.place.rating),
        ViewsWidget(views: widget.place.views),
      ]),
      _PlaceFavIconWidget(place: widget.place),
    ]);
  }
}

class _PlaceBodyWidget extends StatelessWidget {
  const _PlaceBodyWidget({super.key, required this.children});

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

class _PlaceImageWidget extends StatelessWidget {
  const _PlaceImageWidget({super.key, required this.image});

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

class _PlaceTitleWidget extends StatelessWidget {
  const _PlaceTitleWidget({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title);
  }
}

class _PlaceDescriptionWidget extends StatelessWidget {
  const _PlaceDescriptionWidget({super.key, required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    return Text(description);
  }
}

class _PlaceRatingAndViewsWidget extends StatelessWidget {
  const _PlaceRatingAndViewsWidget({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: children,
    );
  }
}

class _PlaceFavIconWidget extends StatelessWidget {
  const _PlaceFavIconWidget({super.key, required this.place});

  final Place place;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainCubit, MainCubitState>(
      builder: (context, state) {
        return Align(
          alignment: Alignment.centerRight,
          child: IconButton(
              onPressed: () {
                context.read<MainCubit>().addOrRemoveFav(place);
              },
              icon: context.read<MainCubit>().checkIfInFav(place)
                  ? const Icon(Icons.favorite, color: Colors.red)
                  : const Icon(Icons.favorite_border)),
        );
      },
    );
  }
}