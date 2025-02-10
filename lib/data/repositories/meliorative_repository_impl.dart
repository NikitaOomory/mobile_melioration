import 'package:mobile_melioration/data/repositories/meliorative_repository.dart';
import 'package:mobile_melioration/data/services/cache_service.dart';

import '../../Models/application.dart';
import '../../Models/melioration_object_model.dart';
import '../meliorative_data_source.dart';

class MeliorativeRepositoryImpl implements MeliorativeRepository {
  final MeliorativeDataSource _dataSource;

  MeliorativeRepositoryImpl(this._dataSource);

  @override
  Future<List<MeliorationObjectModel>> getSystems() async {
    try {
      final isOnline = await CacheService.isOnline();

      if (isOnline) {
        final data = await _dataSource.getSystems();
        await CacheService.saveData('systems', data.map((e) => e.toCacheMap()).toList());
        return data;
      } else {
        final cached = await CacheService.getData('systems');
        return cached.map<MeliorationObjectModel>((e) => MeliorationObjectModel.fromCacheMap(e)).toList();
      }
    } catch (e) {
      print('Error getting systems: $e');
      return [];
    }
  }

  @override
  Future<List<MeliorationObjectModel>> getObjects(String systemId) async {
    try {
      final isOnline = await CacheService.isOnline();

      if (isOnline) {
        final data = await _dataSource.getObjects(systemId);
        await CacheService.saveData('objects_$systemId', data.map((e) => e.toCacheMap()).toList());
        return data;
      } else {
        final cached = await CacheService.getData('objects_$systemId');
        return cached.map<MeliorationObjectModel>((e) => MeliorationObjectModel.fromCacheMap(e)).toList();
      }
    } catch (e) {
      print('Error getting objects for system $systemId: $e');
      return [];
    }
  }

  @override
  Future<List<Application>> getApplications() async {
    try {
      final isOnline = await CacheService.isOnline();

      if (isOnline) {
        final data = await _dataSource.getApplications();
        await CacheService.saveData('applications', data.map((e) => e.toCacheMap()).toList());
        return data;
      } else {
        final cached = await CacheService.getData('applications');
        return cached.map<Application>((e) => Application.fromCacheMap(e)).toList();
      }
    } catch (e) {
      print('Error getting applications: $e');
      return [];
    }
  }

  @override
  Future<void> updateApplication(Application application) async {
    try {
      final isOnline = await CacheService.isOnline();

      if (isOnline) {
        await _dataSource.updateApplication(application);
      }

      final cached = await CacheService.getData('applications');
      final index = cached.indexWhere((a) => a['ref'] == application.ref);

      if (index != -1) {
        cached[index] = application.toCacheMap();
        await CacheService.saveData('applications', cached);
      }
    } catch (e) {
      print('Error updating application: $e');
    }
  }

  @override
  Future<void> syncAllData() async {
    try {
      if (!await CacheService.isOnline()) return;

      final systems = await _dataSource.getSystems();
      await CacheService.saveData('systems', systems.map((e) => e.toCacheMap()).toList());

      for (final system in systems) {
        final objects = await _dataSource.getObjects(system.id);
        await CacheService.saveData('objects_${system.id}', objects.map((e) => e.toCacheMap()).toList());
      }

      final applications = await _dataSource.getApplications();
      await CacheService.saveData('applications', applications.map((e) => e.toCacheMap()).toList());

    } catch (e) {
      print('Error during full sync: $e');
    }
  }
}