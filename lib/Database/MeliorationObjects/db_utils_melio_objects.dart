import 'package:hive/hive.dart';

import '../../Models/melioration_object_model.dart';

class DBUtilsMelioObject{
  Future<void> addObject(MeliorationObjectModel task) async {
    final box = Hive.box<MeliorationObjectModel>('object');
    await box.add(task);
  }

  List<MeliorationObjectModel> getObjects() {
    final box = Hive.box<MeliorationObjectModel>('object');
    return box.values.toList();
  }

  Future<void> updateObject(int index, MeliorationObjectModel task) async {
    final box = Hive.box<MeliorationObjectModel>('object');
    await box.putAt(index, task);
  }

  Future<void> deleteObject(int index) async {
    final box = Hive.box<MeliorationObjectModel>('object');
    await box.deleteAt(index);
  }
}