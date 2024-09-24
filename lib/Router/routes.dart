import '../Features/MainScreen/View/main_screen_scaffold.dart';
import '../Features/MeliorationObjects/View/list_melioration_objects_screen_scaffold.dart';
import '../Features/MeliorationObjects/View/list_objects_in_melio_screen_scaffold.dart';
import '../Features/Support/View/support_screen_scaffold.dart';

final routes = {
'/' : (context) => const MainScreenScaffold(),
'/support' : (context) => const SupportScreenScaffold(),
'/list_melioration_systems' : (context) => const ListMeliorationObjectsScreenScaffold(),
'/list_object_in_melio' : (context) => const ListObjectsInMelioScreenScaffold(),
};