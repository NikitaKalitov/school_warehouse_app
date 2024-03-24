import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/main_cubit.dart';
import '../widgets/place_widget.dart';
import '../widgets/sort_widget.dart';

class AllPlacesPage extends StatefulWidget {
  const AllPlacesPage({super.key});

  @override
  State<AllPlacesPage> createState() => _AllPlacesPageState();
}

class _AllPlacesPageState extends State<AllPlacesPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainCubit, MainCubitState>(
      builder: (context, state) {
        return Stack(
          children: [
            SingleChildScrollView(
              key: const PageStorageKey<String>('allPlaces'),
              child: Column(
                children: [
                  const SizedBox(height: 80),
                  ...state.allPlaces!.map((e) {
                    return PlaceWidget(place: e);
                  }).toList(),
                ],
              ),
            ),
            SortWidget(
              valueKey: const ValueKey('places'),
              currentItem: state.placesSortPattern!,
              function: (String item) {
                context.read<MainCubit>().sortPlaces(item);
              },
            ),
          ],
        );
      },
    );
  }
}
