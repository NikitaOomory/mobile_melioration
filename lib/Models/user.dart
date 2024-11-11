class User {
  final String status;
  final String name;
  final String role;

  User({
    required this.status,
    required this.name,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      status: json['status'] ?? '',
      name: json['user'] ?? '',
      role: json['Role'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'user': name,
      'Role': role,
    };
  }

  User parseUserFromResponse(Map<String, dynamic> responseData) {
    List<dynamic> values = responseData['#value'] ?? []; // Извлекаем массив значений
    String status = '';
    String userName = '';
    String role = '';

    for (var item in values) {
      String name = item['name']['#value'] ?? ''; // Извлекаем имя
      String value = item['Value']['#value'] ?? ''; // Извлекаем значение

      // Сравниваем имя и присваиваем соответствующее значение
      if (name == 'status') {
        status = value;
      } else if (name == 'user') {
        userName = value;
      } else if (name == 'Role') {
        role = value;
      }
    }

    return User(status: status, name: userName, role: role);
  }


}