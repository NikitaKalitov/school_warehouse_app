import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/main_cubit.dart';
import '../widgets/hotel_widget.dart';
import '../widgets/sort_widget.dart';

class AllHotelsPage extends StatefulWidget {
  const AllHotelsPage({super.key});

  @override
  State<AllHotelsPage> createState() => _AllHotelsPageState();
}

class _AllHotelsPageState extends State<AllHotelsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainCubit, MainCubitState>(
      builder: (context, state) {
        return Stack(
          children: [
            SingleChildScrollView(
              key: const PageStorageKey<String>('allHotels'),
              child: Column(
                children: [
                  const SizedBox(height: 80),
                  ...state.allHotels!.map((e) {
                    return HotelWidget(hotel: e);
                  }).toList(),
                ],
              ),
            ),
            SortWidget(
              valueKey: const ValueKey('hotels'),
              currentItem: state.hotelsSortPattern!,
              function: (String item) {
                context.read<MainCubit>().sortHotels(item);
              },
            ),
          ],
        );
      },
    );
  }
}
