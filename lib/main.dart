import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:mobile_melioration/Database/JobApplication/melioration_object_adapter.dart';
import 'package:mobile_melioration/Models/melioration_object_model.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'routes.dart';


void main() async{
  Intl.defaultLocale = 'ru_RU';
  await Hive.initFlutter();
  Hive.registerAdapter(JobApplicationAdapter());
  await Hive.openBox<MeliorationObjectModel>('tasks');
  runApp(const MobileMelioration());
}

class MobileMelioration extends StatelessWidget {
   const MobileMelioration({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [
        Locale('ru', ''),
        Locale('en', ''),
      ],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor:const Color.fromARGB(255, 0, 78, 167),
        appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent),
        scaffoldBackgroundColor: Colors.white,
      ),
      darkTheme: ThemeData(),
      routes: routes,
    );
  }
}


