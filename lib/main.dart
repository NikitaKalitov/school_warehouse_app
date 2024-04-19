import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './logic/main_cubit.dart';
import './ui/pages/main_page.dart';
import 'ui/pages/login_page.dart';

void main() {
  runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider<MainCubit>(
            create: (context) => MainCubit(),
          ),
        ],
        child: const MyApp(),
      ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<MainCubit>().initCubit();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: false,
      ),
      // home: const MainPage(),
      home: const LoginPage(),
    );
  }
}