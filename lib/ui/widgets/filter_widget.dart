import 'package:flutter/material.dart';

class FilterWidget extends StatefulWidget {
  const FilterWidget({
    super.key,
    required this.onChanged,
    required this.items,
    required this.value, required this.type,
  });

  final Function onChanged;
  final List<int> items;
  final int value;
  final List<String> type;

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {

  String getText(int value, List<String> type) {
    if(value == -1){
      return 'Все ${type[1]}';
    }
      else {return '${type[0]} $value';}
  }

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
                    value: item, child: Text(getText(item, widget.type)));
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
