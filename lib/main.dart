import 'package:flutter/material.dart';
import 'package:mobile_melioration/MainScreen/View/scaffold_main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: Colors.pink),
        scaffoldBackgroundColor: Colors.white,
      ),
      darkTheme: ThemeData(),
      home: const MainScreenScaffold(),
    );
  }
}


