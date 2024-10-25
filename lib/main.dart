import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mobile_melioration/Database/JobApplication/melioration_object_adapter.dart';
import 'package:mobile_melioration/Models/melioration_object_model.dart';

import 'routes.dart';


void main() async{
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(backgroundColor: Colors.transparent),
        scaffoldBackgroundColor: Colors.white,
      ),
      darkTheme: ThemeData(),
      routes: routes,
    );
  }
}


