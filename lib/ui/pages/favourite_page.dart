import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/hotel_model.dart';
import '../../data/models/place_model.dart';
import '../../logic/main_cubit.dart';
import '../widgets/favourite_widget.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({super.key});

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainCubit, MainCubitState>(
      builder: (context, state) {
        return Column(
          children: [
            const _FavouritePageText(text: 'Favourite hotels'),
            _FavouritePageHotels(listOfFavHotels: state.favHotels!),
            const _FavouritePageText(text: 'Favourite places'),
            _FavouritePagePlaces(listOfFavPlaces: state.favPlaces!),
          ],
        );
      },
    );
  }
}

class _FavouritePageHotels extends StatelessWidget {
  const _FavouritePageHotels({super.key, required this.listOfFavHotels});

  final List<Hotel> listOfFavHotels;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: SizedBox(
        child: listOfFavHotels.isEmpty
            ? const _FavouritePageEmptyList(item: 'hotels')
            : ListView.builder(
                key: const PageStorageKey<String>('favHotels'),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  Hotel hotel = listOfFavHotels[index];
                  return FavouriteWidget(
                    id: hotel.id,
                    type: 'hotel',
                    image: hotel.image,
                    title: hotel.title,
                  );
                },
                itemCount: listOfFavHotels.length,
              ),
      ),
    );
  }
}

class _FavouritePagePlaces extends StatelessWidget {
  const _FavouritePagePlaces({super.key, required this.listOfFavPlaces});

  final List<Place> listOfFavPlaces;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: SizedBox(
        child: listOfFavPlaces.isEmpty
            ? const _FavouritePageEmptyList(item: 'places')
            : ListView.builder(
                key: const PageStorageKey<String>('favPlaces'),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  Place place = listOfFavPlaces[index];
                  return FavouriteWidget(
                    id: place.id,
                    type: 'place',
                    image: place.image,
                    title: place.title,
                  );
                },
                itemCount: listOfFavPlaces.length,
              ),
      ),
    );
  }
}

class _FavouritePageText extends StatelessWidget {
  const _FavouritePageText({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(text),
    );
  }
}

class _FavouritePageEmptyList extends StatelessWidget {
  const _FavouritePageEmptyList({super.key, required this.item});

  final String item;

  @override
  Widget build(BuildContext context) {
    return FavouriteWidget(
      id: -1,
      type: 'empty',
      image:
          'https://icons.veryicon.com/png/o/commerce-shopping/basic-icon-of-e-commerce/empty-21.png',
      title: 'No favourite $item!',
    );
  }
}
