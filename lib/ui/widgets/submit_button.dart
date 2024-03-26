import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/main_cubit.dart';

class SubmitButton extends StatefulWidget {
  const SubmitButton({super.key, required this.function, required this.text});

  final void Function() function;
  final String text;

  @override
  State<SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<SubmitButton> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: widget.function,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.text),
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Icon(Icons.search),
              ),
            ],
          ),
        ),
        const SizedBox(width: 15,),
        ElevatedButton(
          onPressed: context.read<MainCubit>().reset,
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Сброс'),
              Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Icon(Icons.refresh),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
