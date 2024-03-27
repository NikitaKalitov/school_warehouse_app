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
            FilterWidget(
              key: const Key('filterByStorehouseId'),
              items: state.storehouseFilterItems!,
              value: state.storehouseFilterPattern!,
              onChanged: context.read<MainCubit>().changeStorehouseFilter,
            ),
            if(state.rackFilterItems!.isNotEmpty) FilterWidget(
              key: const Key('filterByRackId'),
              items: state.rackFilterItems!,
              value: state.rackFilterPattern!,
              onChanged: context.read<MainCubit>().changeRackFilter,
            ),
            if(state.shelfFilterItems!.isNotEmpty) FilterWidget(
              key: const Key('filterByShelfId'),
              items: state.shelfFilterItems!,
              value: state.shelfFilterPattern!,
              onChanged: context.read<MainCubit>().changeShelfFilter,
            ),
          ],
        );
      },
    );
  }
}
