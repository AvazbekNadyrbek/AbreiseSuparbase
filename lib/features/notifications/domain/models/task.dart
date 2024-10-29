class Task {
  final String id;
  final String roomId;
  final String assignedTo;
  final String priorityId;
  final String statusId;
  final String description;
  final DateTime createdAt;

  Task({
    required this.id,
    required this.roomId,
    required this.assignedTo,
    required this.priorityId,
    required this.statusId,
    required this.description,
    required this.createdAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      roomId: json['room_id'] as String,
      assignedTo: json['assigned_to'] as String,
      priorityId: json['priority_id'] as String,
      statusId: json['status_id'] as String,
      description: json['description'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'room_id': roomId,
      'assigned_to': assignedTo,
      'priority_id': priorityId,
      'status_id': statusId,
      'description': description,
    };
  }
}
