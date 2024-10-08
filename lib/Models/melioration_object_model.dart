import 'package:hive/hive.dart';



@HiveType(typeId: 0)
class MeliorationObjectModel {

  @HiveField(0)
  final String name;

  @HiveField(1)
  final String typeObject;

  @HiveField(2)
  final String adress;

  @HiveField(3)
  final String author;

  @HiveField(4)
  final String status;

  @HiveField(5)
  final String ein;

  @HiveField(6)
  final String startDate;

  @HiveField(7)
  final String endDate;

  @HiveField(8)
  final String description;

  @HiveField(9)
  final String files;

  @HiveField(10)
  final String techHealth;

  @HiveField(11)
  final String techConditional;

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
      this.techHealth,
      this.techConditional);
}