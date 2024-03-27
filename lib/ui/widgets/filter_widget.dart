import 'package:flutter/material.dart';

// List<DropdownMenuItem> listOfItems = [
//   const DropdownMenuItem(value: -1, child: Text('Все')),
//   const DropdownMenuItem(value: 0, child: Text('Least viewed')),
//   const DropdownMenuItem(value: 'rating desc', child: Text('Highest rating')),
//   const DropdownMenuItem(value: 'rating asc', child: Text('Lowest rating')),
// ];

class FilterWidget extends StatefulWidget {
  const FilterWidget({
    super.key,
    required this.onChanged,
    required this.items,
    required this.value,
  });

  final Function onChanged;
  final List<int> items;
  final int value;

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: double.infinity,
      padding: const EdgeInsets.all(8.0),
      child: Material(
        elevation: 8,
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton(
              items: [-1, ...widget.items].map((item) {
                return DropdownMenuItem(
                    value: item, child: Text(item.toString()));
              }).toList(),
              value: widget.value,
              onChanged: (value) {
                widget.onChanged(value);
              },
            ),
          ),
        ),
      ),
    );
  }
}
