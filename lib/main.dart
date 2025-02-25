import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:mobile_melioration/Database/JobApplication/melioration_object_adapter.dart';
import 'package:mobile_melioration/Models/melioration_object_model.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mobile_melioration/server_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Views/MainScreen/Meleoration_object/list_melioration_objects_screen_scaffold.dart';
import 'data/services/cache_service.dart';
import 'routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  if (prefs.getBool('first_run') ?? true) {
    await _initialCacheLoad();
    prefs.setBool('first_run', false);
  }
  Intl.defaultLocale = 'ru_RU';
  await Hive.initFlutter();
  Hive.registerAdapter(JobApplicationAdapter());
  await Hive.openBox<MeliorationObjectModel>('tasks');
  runApp(const MobileMelioration());
}

Future<void> _initialCacheLoad() async {
  try {
    final dio = Dio();
    final response = await dio.get(ServerRoutes.GET_RECLAMATION_SYSTEM);
    final systems = (response.data['#value'] as List)
        .map((e) => MelObjects.fromJson(e))
        .toList();

    await CacheService.saveData('systems', systems.map((e) => e.toJson()).toList());
  } catch (e) {
    print('Initial cache error: $e');
  }
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
        primaryColor: const Color.fromARGB(255, 0, 78, 167),
        appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
        scaffoldBackgroundColor: Colors.white,
      ),
      darkTheme: ThemeData(),
      routes: routes,
    );
  }
}
