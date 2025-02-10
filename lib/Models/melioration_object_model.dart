import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class MeliorationObjectModel {
  @HiveField(0)
  late final String id; // Добавлено поле id

  @HiveField(1)
  late final String name;

  @HiveField(2)
  final String typeObject;

  @HiveField(3)
  final String adress;

  @HiveField(4)
  late final String author;

  @HiveField(5)
  late final String status;

  @HiveField(6)
  late final String ein;

  @HiveField(7)
  late final String startDate;

  @HiveField(8)
  late final String endDate;

  @HiveField(9)
  late final String description;

  @HiveField(10)
  late final String files;

  @HiveField(11)
  final String techHealth;

  @HiveField(12)
  final String techConditional;

  @HiveField(13)
  final String startJobDate;

  @HiveField(14)
  final String endJobDate;

  @HiveField(15)
  final String prevUnit;

  @HiveField(16)
  final String nextUnit;

  MeliorationObjectModel(
      this.id, // Добавлено поле id
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
      this.techConditional,
      this.startJobDate,
      this.endJobDate,
      this.prevUnit,
      this.nextUnit);

  Map<String, dynamic> toCacheMap() {
    return {
      'id': id, // Добавлено поле id
      'name': name,
      'typeObject': typeObject,
      'adress': adress,
      'author': author,
      'status': status,
      'ein': ein,
      'startDate': startDate,
      'endDate': endDate,
      'description': description,
      'files': files,
      'techHealth': techHealth,
      'techConditional': techConditional,
      'startJobDate': startJobDate,
      'endJobDate': endJobDate,
      'prevUnit': prevUnit,
      'nextUnit': nextUnit,
    };
  }

  factory MeliorationObjectModel.fromCacheMap(Map<String, dynamic> map) {
    return MeliorationObjectModel(
      map['id'] ?? '', // Добавлено поле id
      map['name'] ?? '',
      map['typeObject'] ?? '',
      map['adress'] ?? '',
      map['author'] ?? '',
      map['status'] ?? '',
      map['ein'] ?? '',
      map['startDate'] ?? '',
      map['endDate'] ?? '',
      map['description'] ?? '',
      map['files'] ?? '',
      map['techHealth'] ?? '',
      map['techConditional'] ?? '',
      map['startJobDate'] ?? '',
      map['endJobDate'] ?? '',
      map['prevUnit'] ?? '',
      map['nextUnit'] ?? '',
    );
  }

  factory MeliorationObjectModel.fromJson(Map<String, dynamic> json) {
    return MeliorationObjectModel(
      json['id'] ?? '', // Добавлено поле id
      json['name'] ?? '',
      json['typeObject'] ?? '',
      json['adress'] ?? '',
      json['author'] ?? '',
      json['status'] ?? '',
      json['ein'] ?? '',
      json['startDate'] ?? '',
      json['endDate'] ?? '',
      json['description'] ?? '',
      json['files'] ?? '',
      json['techHealth'] ?? '',
      json['techConditional'] ?? '',
      json['startJobDate'] ?? '',
      json['endJobDate'] ?? '',
      json['prevUnit'] ?? '',
      json['nextUnit'] ?? '',
    );
  }
}