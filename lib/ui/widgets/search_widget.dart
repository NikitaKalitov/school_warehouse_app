import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({
    super.key,
    required this.hint,
    required this.function,
    required this.onlyNumbers,
  });

  final String hint;
  final void Function(String) function;
  final bool onlyNumbers;

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
        hintText: widget.hint,
        suffixIcon: const Icon(Icons.search),
      ),
      onChanged: widget.function,
      keyboardType:
          widget.onlyNumbers ? TextInputType.number : TextInputType.text,
      inputFormatters: widget.onlyNumbers
          ? [FilteringTextInputFormatter.digitsOnly]
          : [],
    );
  }
}
