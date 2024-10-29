import 'package:mobile_melioration/Views/Auth/LoginScreen.dart';
import 'package:mobile_melioration/Views/MainScreen/Application_registry/registry_applications_scaffold.dart';
import 'Views/MainScreen/Meleoration_object/System in object/Function in object/Applications for work/Form/enter_job_application_form.dart';
import 'Views/MainScreen/Meleoration_object/System in object/Function in object/Applications for work/list_enter_job_application.dart';
import 'Views/MainScreen/Meleoration_object/System in object/Function in object/object_function_nav_scaffold.dart';
import 'Views/MainScreen/Meleoration_object/System in object/Function in object/Tech cond/tech_cond_form.dart';
import 'Views/MainScreen/Technical_condition_registry/registry_technical_conditions_scaffold.dart';
import 'Views/MainScreen/main_screen_scaffold.dart';
import 'Views/MainScreen/Meleoration_object/list_melioration_objects_screen_scaffold.dart';
import 'Views/MainScreen/Meleoration_object/System in object/list_objects_in_melio_screen_scaffold.dart';
import 'Views/MainScreen/Support/support_screen_scaffold.dart';

final routes = {
  '/' : (context) => LoginScreen(),
  '/main_screen' : (context) => const MainScreenScaffold(),
  '/support' : (context) => const SupportScreenScaffold(),
  '/list_melioration_systems' : (context) => ListMeliorationObjectsScreenScaffold(),
  '/list_object_in_melio' : (context) =>  ListObjectsInMelioScreenScaffold(),
  '/list_applications' : (context) =>  ListApplicationsScaffold(),
  '/list_technical_conditions' : (context) =>  ListTechnicalConditionsScaffold(),
  '/object_fun_nav' : (context) => const ObjectFunctionNavScaffold(),
  '/list_enter_job_application' : (context) =>  ListEnterJobApplication(),
  '/enter_job_application_form' : (context) =>  EnterJobApplicationForm(),
  '/tech_cond_form' : (context) => TechCondForm(),
};