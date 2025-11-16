class EventCategory {
  final String uuid;
  final String name;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;

  const EventCategory({
    required this.uuid,
    required this.name,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });
}
