import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_2_dasha_eve/ui/widgets/rating_widget.dart';
import 'package:school_2_dasha_eve/ui/widgets/views_widget.dart';

import '../../data/models/hotel_model.dart';
import '../../logic/main_cubit.dart';

const double _padding = 5;
const double _radius = 10;
const double _margin = 10;

class HotelWidget extends StatefulWidget {
  const HotelWidget({super.key, required this.hotel});

  final Hotel hotel;

  @override
  State<HotelWidget> createState() => _HotelWidgetState();
}

class _HotelWidgetState extends State<HotelWidget> {
  @override
  Widget build(BuildContext context) {
    return _HotelBodyWidget(children: [
      _HotelImageWidget(image: widget.hotel.image),
      _HotelTitleWidget(title: widget.hotel.title),
      _HotelAddressWidget(address: widget.hotel.address),
      _HotelRatingAndViewsWidget(children: [
        RatingWidget(rating: widget.hotel.rating),
        ViewsWidget(views: widget.hotel.views),
      ]),
      _HotelFavIconWidget(hotel: widget.hotel),
    ]);
  }
}

class _HotelBodyWidget extends StatelessWidget {
  const _HotelBodyWidget({super.key, required this.children});

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

class _HotelImageWidget extends StatelessWidget {
  const _HotelImageWidget({super.key, required this.image});

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

class _HotelTitleWidget extends StatelessWidget {
  const _HotelTitleWidget({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title);
  }
}

class _HotelAddressWidget extends StatelessWidget {
  const _HotelAddressWidget({super.key, required this.address});

  final String address;

  @override
  Widget build(BuildContext context) {
    return Text(address);
  }
}

class _HotelRatingAndViewsWidget extends StatelessWidget {
  const _HotelRatingAndViewsWidget({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: children,
    );
  }
}

class _HotelFavIconWidget extends StatelessWidget {
  const _HotelFavIconWidget({super.key, required this.hotel});

  final Hotel hotel;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainCubit, MainCubitState>(
      builder: (context, state) {
        return Align(
          alignment: Alignment.centerRight,
          child: IconButton(
              onPressed: () {
                context.read<MainCubit>().addOrRemoveFav(hotel);
              },
              icon: context.read<MainCubit>().checkIfInFav(hotel)
                  ? const Icon(Icons.favorite, color: Colors.red)
                  : const Icon(Icons.favorite_border)),
        );
      },
    );
  }
}
