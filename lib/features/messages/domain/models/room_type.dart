class RoomType {
  final String id;
  final String name;

  RoomType({
    required this.id,
    required this.name,
  });

  factory RoomType.fromJson(Map<String, dynamic> json) {
    return RoomType(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }
}
