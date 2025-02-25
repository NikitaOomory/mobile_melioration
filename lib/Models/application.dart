class Application {
  String ref;
  String owner;
  String reclamationSystem;
  String hydraulicStructure;
  String objectName;
  String startDate;
  String startJobDate;
  String endJobDate;
  String description;
  String number;
  String status;

  Application({
    required this.ref,
    required this.owner,
    required this.reclamationSystem,
    required this.hydraulicStructure,
    required this.objectName,
    required this.startDate,
    required this.startJobDate,
    required this.endJobDate,
    required this.description,
    required this.number,
    required this.status,
  });

  Map<String, dynamic> toCacheMap() {
    return {
      'ref': ref,
      'owner': owner,
      'reclamationSystem': reclamationSystem,
      'hydraulicStructure': hydraulicStructure,
      'objectName': objectName,
      'startDate': startDate,
      'startJobDate': startJobDate,
      'endJobDate': endJobDate,
      'description': description,
      'number': number,
      'status': status,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'ref': ref,
      'owner': owner,
      'reclamationSystem': reclamationSystem,
      'hydraulicStructure': hydraulicStructure,
      'objectName': objectName,
      'startDate': startDate,
      'startJobDate': startJobDate,
      'endJobDate': endJobDate,
      'description': description,
      'number': number,
      'status': status,
    };
  }

  factory Application.fromCacheMap(Map<String, dynamic> map) {
    return Application(
      ref: map['ref'] ?? '',
      owner: map['owner'] ?? '',
      reclamationSystem: map['reclamationSystem'] ?? '',
      hydraulicStructure: map['hydraulicStructure'] ?? '',
      objectName: map['objectName'] ?? '',
      startDate: map['startDate'] ?? '',
      startJobDate: map['startJobDate'] ?? '',
      endJobDate: map['endJobDate'] ?? '',
      description: map['description'] ?? '',
      number: map['number'] ?? '',
      status: map['status'] ?? '',
    );
  }

  factory Application.fromJson(Map<String, dynamic> json) {
    return Application(
      ref: json['ref'] ?? '',
      owner: json['owner'] ?? '',
      reclamationSystem: json['reclamationSystem'] ?? '',
      hydraulicStructure: json['hydraulicStructure'] ?? '',
      objectName: json['objectName'] ?? '',
      startDate: json['startDate'] ?? '',
      startJobDate: json['startJobDate'] ?? '',
      endJobDate: json['endJobDate'] ?? '',
      description: json['description'] ?? '',
      number: json['number'] ?? '',
      status: json['status'] ?? '',
    );
  }
}