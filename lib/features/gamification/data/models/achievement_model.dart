import 'package:poiquest_frontend_flutter/features/gamification/domain/entities/achievement.dart';

class AchievementModel {
  final int id;
  final String key;
  final String name;
  final String? description;
  final String category;
  final int threshold;
  final int points;
  final bool unlocked;

  const AchievementModel({
    required this.id,
    required this.key,
    required this.name,
    this.description,
    required this.category,
    required this.threshold,
    required this.points,
    required this.unlocked,
  });

  factory AchievementModel.fromJson(Map<String, dynamic> json) {
    return AchievementModel(
      id: json['id'] as int,
      key: json['key'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      category: json['category'] as String,
      threshold: json['threshold'] as int,
      points: json['points'] as int,
      unlocked: json['unlocked'] as bool,
    );
  }

  Achievement toEntity() {
    return Achievement(
      id: id,
      key: key,
      name: name,
      description: description,
      category: category,
      threshold: threshold,
      points: points,
      unlocked: unlocked,
    );
  }
}
