import 'package:mobile_melioration/Features/ListApplications/View/list_applications_scaffold.dart';
import 'package:mobile_melioration/Features/ListTechnical%D0%A1onditions/list_technical_conditions_scaffold.dart';
import 'package:mobile_melioration/Features/MeliorationObjects/View/object_function_nav_scaffold.dart';

import '../Features/MainScreen/View/main_screen_scaffold.dart';
import '../Features/MeliorationObjects/View/list_melioration_objects_screen_scaffold.dart';
import '../Features/MeliorationObjects/View/list_objects_in_melio_screen_scaffold.dart';
import '../Features/Support/View/support_screen_scaffold.dart';

final routes = {
  '/' : (context) => const MainScreenScaffold(),
  '/support' : (context) => const SupportScreenScaffold(),
  '/list_melioration_systems' : (context) => const ListMeliorationObjectsScreenScaffold(),
  '/list_object_in_melio' : (context) => const ListObjectsInMelioScreenScaffold(),
  '/list_applications' : (context) => const ListApplicationsScaffold(),
  '/list_technical_conditions' : (context) => const ListTechnicalConditionsScaffold(),
  '/object_fun_nav' : (context) => const ObjectFunctionNavScaffold(),
};