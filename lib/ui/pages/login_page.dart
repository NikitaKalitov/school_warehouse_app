import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/main_cubit.dart';
import 'items_page.dart';
import 'filter_page.dart';
import 'main_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainCubit, MainCubitState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.lightGreen,
          ),
          body: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      suffixIcon: const Icon(Icons.search),
                    ),
                  ),
                  TextField(),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return MainPage();
                          },
                        ),
                      );
                    },
                    child: Text("login"),
                  ),
                ],
                            ),
              ),
          ),
        );
      },
    );
  }
}
