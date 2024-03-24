import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_2_dasha_eve/data/storage/storage_provider.dart';

import '../../logic/main_cubit.dart';
import 'all_hotels_page.dart';
import 'all_places_page.dart';
import 'favourite_page.dart';

const List<Icon> _icons = [
  Icon(Icons.hotel),
  Icon(Icons.place),
  Icon(Icons.favorite),
];

const List<String> _labels = [
  'Hotels',
  'Places',
  'Favourite',
];

List<Widget> _pages = const [
  AllHotelsPage(),
  AllPlacesPage(),
  FavouritePage(),
];

List<BottomNavigationBarItem> _bottomNavBarItems() {
  List<BottomNavigationBarItem> list = [];
  for(int i = 0; i < _pages.length; i++) {
    list.add(BottomNavigationBarItem(icon: _icons[i], label: _labels[i]));
  }
  return list;
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _index = 0;

  @override
  void initState() {
    super.initState();
    // SPrefProvider.removeAllData().then((value) {
    //   context.read<MainCubit>().initCubit();
    // });
    context.read<MainCubit>().initCubit();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainCubit, MainCubitState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text(_labels[_index]), centerTitle: true),
          body: Center(
            child: _pages[_index],
          ),
          bottomNavigationBar: BottomNavigationBar(
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: _bottomNavBarItems(),
            currentIndex: _index,
            onTap: (value) {
              setState(() {
                _index = value;
              });
            },
          ),
        );
      },
    );
  }
}
