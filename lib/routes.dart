import 'package:mobile_melioration/Views/enter_job_application_form.dart';
import 'package:mobile_melioration/Views/list_enter_job_application.dart';
import 'package:mobile_melioration/Views/registry_applications_scaffold.dart';

import 'Views/job_applications_scaffold.dart';
import 'Views/registry_technical_conditions_scaffold.dart';
import 'Views/main_screen_scaffold.dart';
import 'Views/list_melioration_objects_screen_scaffold.dart';
import 'Views/list_objects_in_melio_screen_scaffold.dart';
import 'Views/object_function_nav_scaffold.dart';
import 'Views/support_screen_scaffold.dart';

final routes = {
  '/' : (context) => const MainScreenScaffold(),
  '/support' : (context) => const SupportScreenScaffold(),
  '/list_melioration_systems' : (context) => const ListMeliorationObjectsScreenScaffold(),
  '/list_object_in_melio' : (context) => const ListObjectsInMelioScreenScaffold(),
  '/list_applications' : (context) => const ListApplicationsScaffold(),
  '/list_technical_conditions' : (context) => const ListTechnicalConditionsScaffold(),
  '/object_fun_nav' : (context) => const ObjectFunctionNavScaffold(),
  '/job_application' : (context) => const JobApplicationsScaffold(),
  '/list_enter_job_application' : (context) => const ListEnterJobApplication(),
  '/enter_job_application_form' : (context) => const EnterJobApplicationForm(),
};