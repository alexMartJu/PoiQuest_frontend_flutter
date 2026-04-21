class LevelInfo {
  final int level;
  final String title;
  final int minPoints;
  final int discount;
  final String? reward;

  const LevelInfo({
    required this.level,
    required this.title,
    required this.minPoints,
    required this.discount,
    this.reward,
  });
}
