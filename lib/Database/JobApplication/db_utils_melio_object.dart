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

  Future<int> findTaskIndex({
    required String status,
    required String description,
    required String startJobDate,
    required String endJobDate,
    required String prevUnit,
    required String nextUnit,
  }) async {
    final box = Hive.box<MeliorationObjectModel>('tasks');

// Перебираем все задачи в хранилище
    for (int i = 0; i < box.length; i++) {
      final task = box.getAt(i) as MeliorationObjectModel;

// Проверяем условия на совпадение
      if (task.status == status &&
          task.description == description &&
          task.startJobDate == startJobDate &&
          task.endJobDate == endJobDate &&
          task.prevUnit == prevUnit &&
          task.nextUnit == nextUnit) {
        return i; // Возвращаем индекс найденной задачи
      }
    }
    return -1; // Если не найден, возвращаем -1
  }
}