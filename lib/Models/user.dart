class User {
  final String status;
  final String name;
  final String role;

  // Конструктор класса User
  User({
    required this.status,
    required this.name,
    required this.role,
  });

  // Метод для создания объекта User из JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      status: json['status'] ?? '',
      name: json['user'] ?? '',
      role: json['Role'] ?? '',
    );
  }

  // Метод для сериализации объекта User в JSON
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'user': name,
      'Role': role,
    };
  }


}