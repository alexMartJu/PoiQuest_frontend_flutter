import 'package:poiquest_frontend_flutter/features/gamification/domain/entities/gamification_progress.dart';
import 'package:poiquest_frontend_flutter/features/gamification/domain/entities/gamification_stats.dart';
import 'package:poiquest_frontend_flutter/features/gamification/data/models/achievement_model.dart';
import 'package:poiquest_frontend_flutter/features/gamification/data/models/level_info_model.dart';

class GamificationProgressModel {
  final int totalPoints;
  final int level;
  final String levelTitle;
  final int currentLevelMinPoints;
  final int? nextLevelMinPoints;
  final int discount;
  final Map<String, dynamic> stats;
  final List<AchievementModel> achievements;
  final List<LevelInfoModel> levels;

  const GamificationProgressModel({
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

  factory GamificationProgressModel.fromJson(Map<String, dynamic> json) {
    return GamificationProgressModel(
      totalPoints: json['totalPoints'] as int,
      level: json['level'] as int,
      levelTitle: json['levelTitle'] as String,
      currentLevelMinPoints: json['currentLevelMinPoints'] as int,
      nextLevelMinPoints: json['nextLevelMinPoints'] as int?,
      discount: json['discount'] as int,
      stats: json['stats'] as Map<String, dynamic>,
      achievements: (json['achievements'] as List)
          .map((a) => AchievementModel.fromJson(a as Map<String, dynamic>))
          .toList(),
      levels: (json['levels'] as List?)
          ?.map((l) => LevelInfoModel.fromJson(l as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  GamificationProgress toEntity() {
    return GamificationProgress(
      totalPoints: totalPoints,
      level: level,
      levelTitle: levelTitle,
      currentLevelMinPoints: currentLevelMinPoints,
      nextLevelMinPoints: nextLevelMinPoints,
      discount: discount,
      stats: GamificationStats(
        totalScans: stats['totalScans'] as int,
        completedRoutes: stats['completedRoutes'] as int,
        paidTickets: stats['paidTickets'] as int,
        usedPaidTickets: stats['usedPaidTickets'] as int,
      ),
      achievements: achievements.map((a) => a.toEntity()).toList(),
      levels: levels.map((l) => l.toEntity()).toList(),
    );
  }
}
