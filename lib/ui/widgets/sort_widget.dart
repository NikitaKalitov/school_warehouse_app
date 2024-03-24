import 'package:flutter/material.dart';

List<DropdownMenuItem> listOfItems = [
  const DropdownMenuItem(value: 'views desc', child: Text('Most viewed')),
  const DropdownMenuItem(value: 'views asc', child: Text('Least viewed')),
  const DropdownMenuItem(value: 'rating desc', child: Text('Highest rating')),
  const DropdownMenuItem(value: 'rating asc', child: Text('Lowest rating')),
];

class SortWidget extends StatefulWidget {
  const SortWidget({
    super.key,
    required this.valueKey,
    required this.function,
    required this.currentItem,
  });

  final ValueKey<String> valueKey;
  final void Function(String) function;
  final String currentItem;

  @override
  State<SortWidget> createState() => _SortWidgetState();
}

class _SortWidgetState extends State<SortWidget> {
  String currentItem = 'views desc';

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
              items: listOfItems,
              value: widget.currentItem,
              onChanged: (value) {
                widget.function(value);
              },
            ),
          ),
        ),
      ),
    );
  }
}
