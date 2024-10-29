class Room {
  final String id;
  final String roomNumber;
  final String departmentId;
  final String typeId;
  final DateTime createdAt;

  Room({
    required this.id,
    required this.roomNumber,
    required this.departmentId,
    required this.typeId,
    required this.createdAt,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'] as String,
      roomNumber: json['room_number'] as String,
      departmentId: json['departament_id'] as String,
      typeId: json['type_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'room_number': roomNumber,
      'department_id': departmentId,
      'type_id': typeId,
    };
  }
}
