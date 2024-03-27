import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/main_cubit.dart';
import '../widgets/item_widget.dart';
import '../widgets/search_widget.dart';
import '../widgets/filter_widget.dart';
import '../widgets/submit_button.dart';

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
        return Align(
          alignment: Alignment.topCenter,
          child: Stack(
            alignment: AlignmentDirectional.topCenter,
            children: [
              SingleChildScrollView(
                key: const PageStorageKey<String>('allHotels'),
                child: Column(
                  children: [
                    const SizedBox(height: 180),
                    ...state.searchItems!.map((e) {
                      return ItemWidget(item: e);
                    }),
                  ],
                ),
              ),
              const SearchSection(),
            ],
          ),
        );
      },
    );
  }
}

class SearchSection extends StatefulWidget {
  const SearchSection({super.key});

  @override
  State<SearchSection> createState() => _SearchSectionState();
}

class _SearchSectionState extends State<SearchSection> {

  double padding = 5;
  double radius = 10;
  double margin = 10;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(margin),
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(radius),
        child: IntrinsicHeight(
          child: Column(
            children: [
              SearchWidget(
                key: const Key('titleSearch'),
                hint: 'Введите название',
                function: (String input) {
                  context.read<MainCubit>().onChangedTitleSearch(input);
                },
                onlyNumbers: false,
              ),
              SearchWidget(
                key: const Key('idSearch'),
                hint: 'Введите id',
                function: (String input) {
                  context.read<MainCubit>().onChangedIdSearch(input);
                },
                onlyNumbers: true,
              ),
              SubmitButton(
                key: const Key('submitSearchButton'),
                function: () {
                  context.read<MainCubit>().submitSearch();
                },
                text: 'Поиск',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
