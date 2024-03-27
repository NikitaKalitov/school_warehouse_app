import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/main_cubit.dart';
import '../widgets/filter_widget.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainCubit, MainCubitState>(
      builder: (context, state) {
        return Column(
          children: [
            // фильтр по складам
            FilterWidget(
              key: const Key('filterByStorehouseId'),
              items: state.storehouseFilterItems!,
              value: state.storehouseFilterPattern!,
              type: const ['Склад', 'склады'],
              onChanged: context.read<MainCubit>().changeStorehouseFilter,
            ),
            // фильтр по стеллажам
            // если список пустой, то не отображаем
            if(state.rackFilterItems!.isNotEmpty) FilterWidget(
              key: const Key('filterByRackId'),
              items: state.rackFilterItems!,
              value: state.rackFilterPattern!,
              type: const ['Стеллаж', 'стеллажи'],
              onChanged: context.read<MainCubit>().changeRackFilter,
            ),
            // фильтр по полкам
            // если список пустой, то не отображаем
            if(state.shelfFilterItems!.isNotEmpty) FilterWidget(
              key: const Key('filterByShelfId'),
              items: state.shelfFilterItems!,
              value: state.shelfFilterPattern!,
              type: const ['Полка', 'полки'],
              onChanged: context.read<MainCubit>().changeShelfFilter,
            ),
          ],
        );
      },
    );
  }
}
