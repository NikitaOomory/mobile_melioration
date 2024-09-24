import 'package:flutter/material.dart';

import 'Router/routes.dart';

void main() {
  runApp(const MobileMelioration());
}

class MobileMelioration extends StatelessWidget {
  const MobileMelioration({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: Color.fromARGB(229, 0, 13, 255)),
        scaffoldBackgroundColor: Colors.white,
      ),
      darkTheme: ThemeData(),
      routes: routes,
    );
  }
}


