import 'package:hive/hive.dart';

import '../../Models/melioration_object_model.dart';

class DBUtilsJobApplications{
  Future<void> addTask(MeliorationObjectModel task) async {
    final box = Hive.box<MeliorationObjectModel>('tasks');
    await box.add(task);
  }

  List<MeliorationObjectModel> getTasks() {
    final box = Hive.box<MeliorationObjectModel>('tasks');
    return box.values.toList();
  }

  Future<void> updateTask(int index, MeliorationObjectModel task) async {
    final box = Hive.box<MeliorationObjectModel>('tasks');
    await box.putAt(index, task);
  }

  Future<void> deleteTask(int index) async {
    final box = Hive.box<MeliorationObjectModel>('tasks');
    await box.deleteAt(index);
  }
}