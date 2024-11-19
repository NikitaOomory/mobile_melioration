import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class MeliorationObjectModel {

  @HiveField(0)
  late final String name;

  @HiveField(1)
  final String typeObject;

  @HiveField(2)
  final String adress;

  @HiveField(3)
  late final String author;

  @HiveField(4)
  late final String status;

  @HiveField(5)
  late final String ein;

  @HiveField(6)
  late final String startDate;

  @HiveField(7)
  late final String endDate;

  @HiveField(8)
  late final String description;

  @HiveField(9)
  late final String files;

  @HiveField(10)
  final String techHealth;

  @HiveField(11)
  final String techConditional;

  @HiveField(12)
  final String startJobDate;

  @HiveField(13)
  final String endJobDate;

  @HiveField(14)
  final String prevUnit;

  @HiveField(15)
  final String nextUnit;

  MeliorationObjectModel(
      this.name,
      this.typeObject,
      this.adress,
      this.author,
      this.status,
      this.ein,
      this.startDate,
      this.endDate,
      this.description,
      this.files,
      this.techHealth, // состояние в процентах
      this.techConditional, // состояние по словарю
      this.startJobDate,
      this.endJobDate,
      this.prevUnit,
      this.nextUnit);
}



