import 'package:dio/dio.dart';

import '../Models/application.dart';
import '../Models/melioration_object_model.dart';
import '../server_routes.dart';

abstract class MeliorativeDataSource {
  Future<List<MeliorationObjectModel>> getSystems();
  Future<List<MeliorationObjectModel>> getObjects(String systemId);
  Future<List<Application>> getApplications();
  Future<void> updateApplication(Application application);
}

class MeliorativeDataSourceImpl implements MeliorativeDataSource {
  final Dio dio;

  MeliorativeDataSourceImpl(this.dio);

  @override
  Future<List<MeliorationObjectModel>> getSystems() async {
    final response = await dio.get(ServerRoutes.GET_RECLAMATION_SYSTEM);
    return (response.data['#value'] as List)
        .map((e) => MeliorationObjectModel.fromJson(e))
        .toList();
  }

  @override
  Future<List<MeliorationObjectModel>> getObjects(String systemId) async {
    final response = await dio.post(
      ServerRoutes.GET_OBJECTS_OF_RECLAMATION_SYSTEM,
      data: {'ref': systemId},
    );
    return (response.data['#value'] as List)
        .map((e) => MeliorationObjectModel.fromJson(e))
        .toList();
  }

  @override
  Future<List<Application>> getApplications() async {
    final response = await dio.get(ServerRoutes.GET_APPLICATIONS_FOR_WORK);
    return (response.data['#value'] as List)
        .map((e) => Application.fromJson(e))
        .toList();
  }

  @override
  Future<void> updateApplication(Application application) async {
    await dio.post(
      ServerRoutes.WRITE_APPLICATION_FOR_WORK,
      data: application.toJson(),
    );
  }
}