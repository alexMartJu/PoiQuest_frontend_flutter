import 'package:poiquest_frontend_flutter/features/gamification/domain/entities/achievement.dart';
import 'package:poiquest_frontend_flutter/features/gamification/domain/entities/gamification_stats.dart';
import 'package:poiquest_frontend_flutter/features/gamification/domain/entities/level_info.dart';

class GamificationProgress {
  final int totalPoints;
  final int level;
  final String levelTitle;
  final int currentLevelMinPoints;
  final int? nextLevelMinPoints;
  final int discount;
  final GamificationStats stats;
  final List<Achievement> achievements;
  final List<LevelInfo> levels;

  const GamificationProgress({
    required this.totalPoints,
    required this.level,
    required this.levelTitle,
    required this.currentLevelMinPoints,
    this.nextLevelMinPoints,
    required this.discount,
    required this.stats,
    required this.achievements,
    required this.levels,
  });

  /// Progreso hacia el siguiente nivel (0.0 - 1.0)
  double get levelProgress {
    if (nextLevelMinPoints == null) return 1.0;
    final range = nextLevelMinPoints! - currentLevelMinPoints;
    if (range <= 0) return 1.0;
    final progress = (totalPoints - currentLevelMinPoints) / range;
    return progress.clamp(0.0, 1.0);
  }

  /// Puntos que faltan para el siguiente nivel
  int get pointsToNextLevel {
    if (nextLevelMinPoints == null) return 0;
    return (nextLevelMinPoints! - totalPoints).clamp(0, nextLevelMinPoints!);
  }

  /// Logros desbloqueados
  List<Achievement> get unlockedAchievements =>
      achievements.where((a) => a.unlocked).toList();

  /// Logros bloqueados
  List<Achievement> get lockedAchievements =>
      achievements.where((a) => !a.unlocked).toList();
}
