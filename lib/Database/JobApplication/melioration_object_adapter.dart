import 'package:hive/hive.dart';

import '../../Models/melioration_object_model.dart';

class JobApplicationAdapter extends TypeAdapter<MeliorationObjectModel> {
  @override
  final int typeId = 0;

  @override
  MeliorationObjectModel read(BinaryReader reader) {
    final id = reader.read() as String; // Чтение поля id
    final name = reader.read() as String;
    final typeObject = reader.read() as String;
    final address = reader.read() as String;
    final author = reader.read() as String;
    final status = reader.read() as String;
    final ein = reader.read() as String;
    final startDate = reader.read() as String;
    final endDate = reader.read() as String;
    final description = reader.read() as String;
    final files = reader.read() as String;
    final techHealth = reader.read() as String;
    final techConditional = reader.read() as String;
    final startJobDate = reader.read() as String;
    final endJobDate = reader.read() as String;
    final prevUnit = reader.read() as String;
    final nextUnit = reader.read() as String;

    return MeliorationObjectModel(
      id, // Передача поля id
      name,
      typeObject,
      address,
      author,
      status,
      ein,
      startDate,
      endDate,
      description,
      files,
      techHealth,
      techConditional,
      startJobDate,
      endJobDate,
      prevUnit,
      nextUnit,
    );
  }

  @override
  void write(BinaryWriter writer, MeliorationObjectModel obj) {
    writer.write(obj.id); // Запись поля id
    writer.write(obj.name);
    writer.write(obj.typeObject);
    writer.write(obj.adress);
    writer.write(obj.author);
    writer.write(obj.status);
    writer.write(obj.ein);
    writer.write(obj.startDate);
    writer.write(obj.endDate);
    writer.write(obj.description);
    writer.write(obj.files);
    writer.write(obj.techHealth);
    writer.write(obj.techConditional);
    writer.write(obj.startJobDate);
    writer.write(obj.endJobDate);
    writer.write(obj.prevUnit);
    writer.write(obj.nextUnit);
  }
}