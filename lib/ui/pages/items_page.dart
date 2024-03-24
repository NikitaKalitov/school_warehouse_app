import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_warehouse_app/ui/widgets/item_widget.dart';

import '../../logic/main_cubit.dart';
import '../widgets/sort_widget.dart';

class ItemsPage extends StatefulWidget {
  const ItemsPage({super.key});

  @override
  State<ItemsPage> createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
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
                  ...state.allItems!.map((e) {
                    return ItemWidget(item: e);
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
    );;
  }
}
