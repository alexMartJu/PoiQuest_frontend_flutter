class Achievement {
  final int id;
  final String key;
  final String name;
  final String? description;
  final String category;
  final int threshold;
  final int points;
  final bool unlocked;

  const Achievement({
    required this.id,
    required this.key,
    required this.name,
    this.description,
    required this.category,
    required this.threshold,
    required this.points,
    required this.unlocked,
  });
}
