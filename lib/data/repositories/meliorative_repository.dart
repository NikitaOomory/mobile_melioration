import '../../Models/application.dart';
import '../../Models/melioration_object_model.dart';

abstract class MeliorativeRepository {
  Future<List<MeliorationObjectModel>> getSystems();
  Future<List<MeliorationObjectModel>> getObjects(String systemId);
  Future<List<Application>> getApplications();
  Future<void> updateApplication(Application application);
  Future<void> syncAllData();
}