class Department {
  final String id;
  final String name;
  final DateTime createdAt;

  Department({
    required this.id,
    required this.name,
    required this.createdAt,
  });

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: json['id'] as String,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}
